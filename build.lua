#!/usr/bin/env texlua

-- Build script for "beamer" files

-- Identify the bundle and module
bundle = ""
module = "beamer"

-- Non-standard structure
docfiledir    = "./doc"
sourcefiledir = "./base"
flattentds = false

-- Install all files from the source tree directly
installfiles = {"**/*.cls", "**/*.sty", "**/beamericon*.*"}
sourcefiles  = installfiles
unpackfiles  = { }

-- Typeset only the main documentation file,
-- but make all sources available
docfiles     =
  {
    "**/*.jpg", 
    "**/*.tex",
    "**/*.txt",
    "**/beamerlogo.pdf",
    "**/beamerexample-lecture-logo.pdf"
  }
typesetfiles = 
  {
    "beameruserguide.tex",
    "beamerexample-conference-talk.tex",
    "beamerexample-lecture-beamer-version.tex",
    "beamerexample-lecture-print-version.tex"
  }

-- Only copy Markdown files to main dir
textfiles = {"*.md"}

-- Custom clean-up settings
cleanfiles = {"beameruserguide.pdf", "*.zip"}

-- Test set up
checkengines   = {"pdftex"}
checksuppfiles = {"*.tex"}

-- Use standard MakeIndex style
indexstyle = ""

-- Auto-versioning
tagfiles = {"beamer.cls", "beamerarticle.sty", "beameruserguide.tex", "CHANGELOG.md"}
function update_tag(file,content,tagname,tagdate)
  local tagdate = string.gsub(tagdate,"%-","/")
  if string.match(file,"%.tex") then
    return string.gsub(content,
      "\\def\\beamerugversion{%d%.%d+}",
      "\\def\\beamerugversion{" .. string.gsub(tagname,"^v","") .. "}")
  elseif string.match(file,"CHANGELOG.md") then
    local url = "https://github.com/josephwright/beamer/compare/"
    local previous = string.match(content,"compare/(v%d%.%d%d)%.%.%.HEAD")
    if tagname == previous then return content end
    content = string.gsub(content,
      "## %[Unreleased%]",
      "## [Unreleased]\n\n## [" .. tagname .."]")
    return string.gsub(content,
      "v%d.%d%d%.%.%.HEAD",
      tagname .. "...HEAD\n[" .. tagname .. "]: " .. url .. previous
        .. "..." .. tagname)
  else
    return string.gsub(content,
      "%d%d%d%d/%d%d/%d%d v?%d%.%d+",
      tagdate .. " " .. tagname)
  end
end

-- Release a TDS-style zip
packtdszip = true

-- Preserve structure for CTAN
flatten = false

-- Custom data for the theme demos
themes =
  {
    core = 
      {
        "AnnArbor", "Antibes", "Berkeley", "Berlin", "Bergen", "Boadilla",
        "Copenhagen", "Darmstadt", "Dresden", "EastLansing", "Frankfurt",
        "Goettingen", "Hannover", "Ilmenau", "JuanLesPins", "Luebeck",
        "Malmoe", "Madrid", "Marburg", "Montpellier", "PaloAlto",
        "Pittsburgh", "Rochester", "Singapore", "Szeged", "Warsaw",
        "CambridgeUS", "default", "boxes"
      },
    font = 
      {
        "default", "serif", "structurebold", "structureitalicserif",
        "structuresmallcapsserif"
      },
    color =
      {
        "default", "crane", "albatross", "seahorse", "whale", "dolphin",
        "rose", "orchid", "sidebartab", "lily", "structure", "dove", "seagull",
        "beetle", "fly", "wolverine", "spruce", "beaver", "monarca",
        "albatrossstylish" -- This is a special case: see the .tex file
      },
    outer =
      {
        "default", "infolines", "miniframes", "shadow", "sidebar",
        "smoothbars", "smoothtree", "split", "tree"
      },
    inner = {"default", "circles", "rectangles", "rounded", "inmargin"}
  }

function typeset_demo_tasks()
  local errorlevel = 0
  for type,themelist in pairs(themes) do
    local themetype = ""
    if  type~= "core" then themetype = tostring(type) end
    local name = "beamer" .. themetype .. "themeexample.tex"
    for _,theme in pairs(themelist) do
      errorlevel = errorlevel + runcmd(
        "pdflatex \"\\def\\themename{" .. theme .. "}"
          .. "\\input " .. name .. "\" ",
          typesetdir, {"TEXINPUTS"}
      )
      if errorlevel ~= 0 then
        return errorlevel
      end
      ren(typesetdir,
        string.gsub(name, "%.tex$", ".pdf"),
        "beamerug" .. themetype .. "theme" .. theme .. ".pdf")
    end
  end
  return 0
end

-- Find and run the build system
kpse.set_program_name ("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end
