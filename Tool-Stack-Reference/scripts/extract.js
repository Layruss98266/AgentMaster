/**
 * extract.js — Parse master-hub.html → JSON intermediates
 *
 * Prerequisites:
 *   1. Obtain master-hub.html and place it at Tool-Stack-Reference/master-hub.html
 *
 * Usage (from repo root or Tool-Stack-Reference/scripts/):
 *   node Tool-Stack-Reference/scripts/extract.js
 *   # OR
 *   cd Tool-Stack-Reference/scripts && node extract.js
 *
 * Outputs (written to Tool-Stack-Reference/, gitignored):
 *   hub-tools-out.json   — tools grouped by category
 *   hub-tech-out.json    — tech items grouped by category
 *   hub-summary.json     — category counts / names
 *
 * Next step: node Tool-Stack-Reference/scripts/generate-md.js
 */

const fs = require('fs');
const path = require('path');

const TSR_DIR = path.join(__dirname, '..');

try {
  const htmlPath = path.join(TSR_DIR, 'master-hub.html');
  process.stderr.write('Reading HTML file...\n');
  const content = fs.readFileSync(htmlPath, 'utf8');
  process.stderr.write('File read, length: ' + content.length + '\n');

  function extractJSON(varName) {
    const marker = varName + ' = ';
    const start = content.indexOf(marker);
    if (start === -1) throw new Error('Could not find ' + varName);
    const dataStart = start + marker.length;
    const scriptEnd = content.indexOf('</script>', dataStart);
    if (scriptEnd === -1) throw new Error('Could not find end of ' + varName);
    let jsonStr = content.substring(dataStart, scriptEnd).trim();
    if (jsonStr.endsWith(';')) jsonStr = jsonStr.slice(0, -1);
    process.stderr.write('Parsing ' + varName + ', json length: ' + jsonStr.length + '\n');
    return JSON.parse(jsonStr);
  }

  process.stderr.write('Extracting TOOLS_DATA...\n');
  const toolsData = extractJSON('window.__TOOLS_DATA__');
  // __TOOLS_DATA__ may be {tools:[...]} object or a plain array
  const tools = Array.isArray(toolsData) ? toolsData : (toolsData.tools || toolsData.data || Object.values(toolsData)[0]);
  process.stderr.write('Got ' + tools.length + ' tools\n');

  process.stderr.write('Extracting TECH_DATA...\n');
  const techData = extractJSON('window.__TECH_DATA__');
  process.stderr.write('Got ' + techData.length + ' tech items\n');

  function groupToolsByCategory(tools) {
    const categories = {};

    for (const tool of tools) {
      if (!tool.placements || !Array.isArray(tool.placements)) continue;

      const seenCategories = new Set();

      for (const placement of tool.placements) {
        if (placement.tabId === 'tab-0') continue;

        const catKey = placement.tabId || 'unknown';
        const catName = placement.tabName || placement.tabId || 'Unknown';
        const groupName = placement.groupName || placement.group || 'General';

        if (!categories[catKey]) {
          categories[catKey] = { id: catKey, name: catName, groups: {} };
        }

        if (!categories[catKey].groups[groupName]) {
          categories[catKey].groups[groupName] = [];
        }

        if (!seenCategories.has(catKey)) {
          seenCategories.add(catKey);

          const isFree = !!(tool.open_source || tool.has_free_plan ||
            ['Free', 'Open Source', 'Freemium'].includes(tool.pricing));

          categories[catKey].groups[groupName].push({
            name: tool.name || '',
            pricing: tool.pricing || 'Unknown',
            tagline: (tool.tagline || tool.description || '').substring(0, 60),
            url: tool.url || tool.website || '',
            isFree: isFree,
            rank: tool.final_rank_score || 0
          });
        }
      }
    }

    for (const cat of Object.values(categories)) {
      for (const group of Object.values(cat.groups)) {
        group.sort(function(a, b) {
          if (a.isFree && !b.isFree) return -1;
          if (!a.isFree && b.isFree) return 1;
          return (b.rank || 0) - (a.rank || 0);
        });
      }
    }

    return categories;
  }

  function groupTechByCategory(techItems) {
    const categories = {};
    for (const item of techItems) {
      const catName = item.category || item.type || 'General';
      if (!categories[catName]) categories[catName] = [];
      categories[catName].push({
        name: item.name || '',
        type: item.type || '',
        description: (item.description || item.tagline || '').substring(0, 80),
        url: item.url || item.website || item.github || '',
        stars: item.github_stars || item.stars || 0,
        language: item.language || ''
      });
    }
    return categories;
  }

  process.stderr.write('Grouping tools by category...\n');
  const toolsGrouped = groupToolsByCategory(tools);

  process.stderr.write('Grouping tech by category...\n');
  const techGrouped = groupTechByCategory(techData);

  process.stderr.write('Writing output files...\n');
  fs.writeFileSync(path.join(TSR_DIR, 'hub-tools-out.json'), JSON.stringify(toolsGrouped, null, 2));
  fs.writeFileSync(path.join(TSR_DIR, 'hub-tech-out.json'), JSON.stringify(techGrouped, null, 2));

  const summary = {
    toolsCategories: Object.keys(toolsGrouped).length,
    techCategories: Object.keys(techGrouped).length,
    toolsCategoryNames: Object.values(toolsGrouped).map(function(c) {
      return { id: c.id, name: c.name, count: Object.values(c.groups).reduce(function(s, g) { return s + g.length; }, 0) };
    }),
    techCategoryNames: Object.keys(techGrouped).map(function(k) {
      return { name: k, count: techGrouped[k].length };
    })
  };
  fs.writeFileSync(path.join(TSR_DIR, 'hub-summary.json'), JSON.stringify(summary, null, 2));

  process.stderr.write('Done! Tool categories: ' + Object.keys(toolsGrouped).length +
    ', Tech categories: ' + Object.keys(techGrouped).length + '\n');
  process.stderr.write('Next step: node Tool-Stack-Reference/scripts/generate-md.js\n');
} catch (e) {
  process.stderr.write('ERROR: ' + e.message + '\n');
  process.stderr.write(e.stack + '\n');
  process.exit(1);
}
