const fs = require('fs');
const path = require('path');

const OUT_DIR = path.join(__dirname, 'hub');
const SKIP_CATS = new Set(['tool-cat-browser']); // exclude browser extensions per user rule

const CAT_NAMES = {
  'tool-cat-coding':      'AI Coding Tools',
  'tool-cat-seo':         'SEO & Content AI',
  'tool-cat-video':       'Video AI',
  'tool-cat-meeting':     'Meeting & Productivity AI',
  'tool-cat-image':       'Image Generation AI',
  'tool-cat-security':    'Cybersecurity Tools',
  'tool-cat-3d-game':     '3D & Game Development',
  'tool-cat-agents':      'AI Agents & Automation',
  'tool-cat-design':      'Design Tools',
  'tool-cat-api-dev':     'API & Developer Tools',
  'tool-cat-sales':       'Sales & CRM AI',
  'tool-cat-research':    'AI Research Tools',
  'tool-cat-hr':          'HR & Recruiting AI',
  'tool-cat-ecommerce':   'Ecommerce AI',
  'tool-cat-finance':     'Finance & Fintech AI',
  'tool-cat-learning':    'Learning & Education AI',
  'tool-cat-infra':       'AI Infrastructure',
  'tool-cat-project':     'Project Management AI',
  'tool-cat-marketing':   'Marketing AI',
  'tool-cat-writing':     'Writing & Content AI',
  'tool-cat-support':     'Customer Support AI',
  'tool-cat-legal':       'Legal & Compliance AI',
  'tool-cat-streaming':   'Streaming & Live Video',
  'tool-cat-pkm':         'Personal Knowledge Management',
  'tool-cat-social':      'Social Media AI',
  'tool-cat-chatbots':    'Chatbots & Conversational AI',
  'tool-cat-podcasting':  'Podcasting Tools',
  'tool-cat-translation': 'Translation & Localization AI',
  'tool-cat-search':      'AI Search',
  'tool-cat-data':        'Data & Analytics AI',
  'tool-cat-audio':       'Audio AI',
  'tool-cat-productivity':'Productivity AI',
};

const CAT_SLUGS = {
  'tool-cat-coding':      'ai-coding',
  'tool-cat-seo':         'seo-content',
  'tool-cat-video':       'video-ai',
  'tool-cat-meeting':     'meeting-productivity',
  'tool-cat-image':       'image-ai',
  'tool-cat-security':    'cybersecurity',
  'tool-cat-3d-game':     '3d-game-dev',
  'tool-cat-agents':      'ai-agents',
  'tool-cat-design':      'design-tools',
  'tool-cat-api-dev':     'api-dev-tools',
  'tool-cat-sales':       'sales-crm',
  'tool-cat-research':    'ai-research',
  'tool-cat-hr':          'hr-recruiting',
  'tool-cat-ecommerce':   'ecommerce',
  'tool-cat-finance':     'finance-fintech',
  'tool-cat-learning':    'learning-education',
  'tool-cat-infra':       'ai-infra',
  'tool-cat-project':     'project-management',
  'tool-cat-marketing':   'marketing',
  'tool-cat-writing':     'writing-content',
  'tool-cat-support':     'customer-support',
  'tool-cat-legal':       'legal-compliance',
  'tool-cat-streaming':   'streaming-video',
  'tool-cat-pkm':         'pkm-notes',
  'tool-cat-social':      'social-media',
  'tool-cat-chatbots':    'chatbots',
  'tool-cat-podcasting':  'podcasting',
  'tool-cat-translation': 'translation',
  'tool-cat-search':      'ai-search',
  'tool-cat-data':        'data-analytics',
  'tool-cat-audio':       'audio-ai',
  'tool-cat-productivity':'productivity',
};

function pricingBadge(pricing, isFree) {
  if (isFree) {
    if (pricing === 'Open Source' || pricing === 'Free') return '🆓 Free';
    if (pricing === 'Freemium') return '🆓 Freemium';
    return '🆓 Free tier';
  }
  return '💰 ' + (pricing || 'Paid');
}

function cleanUrl(url) {
  if (!url) return '';
  return url.replace(/^https?:\/\//, '').replace(/\/$/, '');
}

function generateToolsMd(catId, catData) {
  const title = CAT_NAMES[catId] || catData.name || catId;
  const lines = ['# ' + title, ''];

  const groups = catData.groups;
  const groupNames = Object.keys(groups);

  for (const groupName of groupNames) {
    const tools = groups[groupName];
    if (!tools || tools.length === 0) continue;

    lines.push('## ' + groupName);
    lines.push('');
    lines.push('| Tool | Pricing | Tagline | URL |');
    lines.push('|------|---------|---------|-----|');

    for (const t of tools) {
      const name = t.name || '';
      const badge = pricingBadge(t.pricing, t.isFree);
      const tagline = (t.tagline || '').replace(/\|/g, '-').substring(0, 55);
      const url = cleanUrl(t.url);
      lines.push('| **' + name + '** | ' + badge + ' | ' + tagline + ' | ' + url + ' |');
    }
    lines.push('');
  }

  return lines.join('\n');
}

function generateTechMd(catName, items) {
  const title = catName.replace(/_/g, ' ').replace(/\b\w/g, c => c.toUpperCase());
  const lines = ['# Tech Reference: ' + title, ''];

  lines.push('| Name | Description | URL |');
  lines.push('|------|-------------|-----|');

  for (const item of items) {
    const name = (item.name || '').replace(/\|/g, '-');
    const desc = (item.description || '').replace(/\|/g, '-').substring(0, 70);
    const url = item.url || '';
    const cleanedUrl = url.replace(/^https?:\/\//, '').replace(/\/$/, '');
    lines.push('| **' + name + '** | ' + desc + ' | ' + cleanedUrl + ' |');
  }

  lines.push('');
  return lines.join('\n');
}

// Load data
const toolsGrouped = JSON.parse(fs.readFileSync(path.join(__dirname, 'hub-tools-out.json'), 'utf8'));
const techGrouped = JSON.parse(fs.readFileSync(path.join(__dirname, 'hub-tech-out.json'), 'utf8'));

// Create output dir
if (!fs.existsSync(OUT_DIR)) fs.mkdirSync(OUT_DIR, { recursive: true });

// Generate tool markdown files
let toolFileCount = 0;
for (const [catId, catData] of Object.entries(toolsGrouped)) {
  if (SKIP_CATS.has(catId)) {
    process.stderr.write('Skipping ' + catId + ' (browser/website tools)\n');
    continue;
  }

  const slug = CAT_SLUGS[catId] || catId.replace('tool-cat-', '');
  const filename = 'tools-' + slug + '.md';
  const content = generateToolsMd(catId, catData);
  fs.writeFileSync(path.join(OUT_DIR, filename), content);
  toolFileCount++;
}

// Generate tech markdown files
let techFileCount = 0;
for (const [catName, items] of Object.entries(techGrouped)) {
  if (!items || items.length === 0) continue;
  const slug = catName.replace(/_/g, '-').toLowerCase();
  const filename = 'tech-' + slug + '.md';
  const content = generateTechMd(catName, items);
  fs.writeFileSync(path.join(OUT_DIR, filename), content);
  techFileCount++;
}

// Generate index
const indexLines = [
  '# Hub Tool & Tech Reference Index',
  '',
  '> Extracted from Master Dev Hub. Free/OSS tools listed first. Browser extensions excluded.',
  '',
  '## Tools by Category (' + toolFileCount + ' categories)',
  '',
];

const toolCats = Object.entries(toolsGrouped)
  .filter(([id]) => !SKIP_CATS.has(id))
  .map(([id, cat]) => {
    const count = Object.values(cat.groups).reduce((s, g) => s + g.length, 0);
    return { id, name: CAT_NAMES[id] || cat.name, slug: CAT_SLUGS[id] || id.replace('tool-cat-',''), count };
  })
  .sort((a, b) => b.count - a.count);

for (const c of toolCats) {
  indexLines.push('- [' + c.name + '](tools-' + c.slug + '.md) — ' + c.count + ' tools');
}

indexLines.push('');
indexLines.push('## Tech by Category (' + techFileCount + ' categories)');
indexLines.push('');

const techCats = Object.entries(techGrouped)
  .map(([name, items]) => ({ name, slug: name.replace(/_/g, '-').toLowerCase(), count: items.length }))
  .sort((a, b) => b.count - a.count);

for (const c of techCats) {
  indexLines.push('- [' + c.name.replace(/_/g, ' ') + '](tech-' + c.slug + '.md) — ' + c.count + ' items');
}

indexLines.push('');
fs.writeFileSync(path.join(OUT_DIR, 'README.md'), indexLines.join('\n'));

process.stderr.write('Generated ' + toolFileCount + ' tool files + ' + techFileCount + ' tech files\n');
process.stderr.write('Index written to hub/README.md\n');
