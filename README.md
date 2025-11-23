# taskman.nvim
A tiny Neovim plugin for extracting Markdown task lists (- [ ] and - [x]) from a directory and displaying them in vims native selection tool (vim.ui.select) with jump navigation and fuzzy finding.

![Example](https://private-user-images.githubusercontent.com/69520285/517763952-dcee1817-0245-4525-a1c0-f96c40699d73.gif?jwt=eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJnaXRodWIuY29tIiwiYXVkIjoicmF3LmdpdGh1YnVzZXJjb250ZW50LmNvbSIsImtleSI6ImtleTUiLCJleHAiOjE3NjM4ODI1NjIsIm5iZiI6MTc2Mzg4MjI2MiwicGF0aCI6Ii82OTUyMDI4NS81MTc3NjM5NTItZGNlZTE4MTctMDI0NS00NTI1LWExYzAtZjk2YzQwNjk5ZDczLmdpZj9YLUFtei1BbGdvcml0aG09QVdTNC1ITUFDLVNIQTI1NiZYLUFtei1DcmVkZW50aWFsPUFLSUFWQ09EWUxTQTUzUFFLNFpBJTJGMjAyNTExMjMlMkZ1cy1lYXN0LTElMkZzMyUyRmF3czRfcmVxdWVzdCZYLUFtei1EYXRlPTIwMjUxMTIzVDA3MTc0MlomWC1BbXotRXhwaXJlcz0zMDAmWC1BbXotU2lnbmF0dXJlPTdlNzgwOGMwNGI5YTIzYTM4MDhhNTgwODU2MzdiYzI5NjAyMDMwM2M2ZmRhYTdmOGM4MzRhNjgxMGQzMjNkOTAmWC1BbXotU2lnbmVkSGVhZGVycz1ob3N0In0.EiX8EoH-Zjfkq4saXAK582C9DVBFYFbDv_VbSJmVUjI) 

Uses fast ripgrep (rg --vimgrep) and Neovim’s built-in quickfix parser.

## Installation
Install using your favorite package manager.

### Lazy
```lua
return {
  {
    "Jonathan-Al-Saadi/taskman.nvim",
    opts = {
      -- Directory to search for markdown task files
      task_dir = "~/Documents/YOUR-DIRECTORY-HERE",
    },
  },
}
```
## Features
- Find unfinished and finished tasks (- [ ] / - [x/X])
- Jump to file + line on selection
- Configurable root directory
- No dependencies 

### Confiugration
Set the task_dir (string) in opts. This should be the directory where your Markdown files live.

```lua
task_dir = "~/Documents/YOUR-DIRECTORY-HERE",
```

If omitted, it defaults to:

```vim
vim.fn.getcwd()
```

## Usage
`:TaskList`

Lists all incomplete tasks (default).

`:TaskList todo`

Same as above — incomplete tasks (- [ ]).

`:TaskList done`

Lists completed tasks (- [x], - [X]).

### Example
```markdown
# Meeting notes

- [ ] Write documentation
- [ ] Add Snacks picker support
- [x] Implement jump navigation
```
Running:

`:TaskList`
Shows:
```markdown
/path/file.md:3  - [ ] Write documentation
/path/file.md:4  - [ ] Add Snacks picker support
```
Running:
:TaskList done

Shows
```markdown
/path/file.md:5  - [x] Implement jump navigation
```
