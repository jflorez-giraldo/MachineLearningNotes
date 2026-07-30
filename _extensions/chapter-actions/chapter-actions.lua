-- Reusable chapter action buttons for the HTML version
-- of the Quarto book.

local function file_stem(path)
  -- Extract the file name from a complete path.
  local filename = path:match("([^/\\]+)$") or path

  -- Remove the final file extension.
  return filename:gsub("%.[^%.]+$", "")
end


local function normalize_offset(offset)
  -- Files in the project root may have no offset.
  if offset == nil or offset == "." then
    return ""
  end

  -- Ensure that the offset ends with a slash.
  if offset ~= "" and not offset:match("/$") then
    offset = offset .. "/"
  end

  return offset
end


return {
  ["chapter-actions"] = function(args, kwargs, meta)

    -- The buttons are intended for the HTML book.
    -- They are omitted from the printed PDF.
    if not quarto.doc.is_format("html") then
      return pandoc.Null()
    end

    local input_file = quarto.doc.input_file

    if input_file == nil then
      return pandoc.Null()
    end

    local chapter_name = file_stem(input_file)
    local project_offset = normalize_offset(
      quarto.project.offset
    )

    local notebook_path =
      project_offset
      .. "notebooks/"
      .. chapter_name
      .. ".ipynb"

    local pdf_path =
      project_offset
      .. "machine-learning-I.pdf"

    local html = string.format(
      [[
<div class="chapter-actions" aria-label="Chapter resources">

  <a
    class="chapter-action chapter-action-notebook"
    href="%s"
    download
  >
    <i class="bi bi-download" aria-hidden="true"></i>
    <span>Download Notebook</span>
  </a>

  <a
    class="chapter-action chapter-action-pdf"
    href="%s"
    download
  >
    <i class="bi bi-file-earmark-pdf" aria-hidden="true"></i>
    <span>Download Book PDF</span>
  </a>

</div>
]],
      notebook_path,
      pdf_path
    )

    return pandoc.RawBlock("html", html)
  end
}