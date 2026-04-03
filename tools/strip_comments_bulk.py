#!/usr/bin/env python3
"""Bulk strip comments from source files. Preserves SPDX-License-Identifier lines."""

from __future__ import annotations

import os
import sys
import tokenize
import io


def preserve_spdx_lines(text: str) -> list[str]:
    out = []
    for line in text.splitlines():
        if "SPDX-License-Identifier" in line:
            out.append(line)
    return out


def strip_c_style(text: str) -> str:
    out: list[str] = []
    i = 0
    n = len(text)
    in_string = False
    escape = False
    in_line = False
    in_block = False
    while i < n:
        if in_line:
            if text[i] == "\n":
                in_line = False
                out.append("\n")
            i += 1
            continue
        if in_block:
            if text[i] == "*" and i + 1 < n and text[i + 1] == "/":
                in_block = False
                i += 2
            else:
                i += 1
            continue
        if in_string:
            c = text[i]
            out.append(c)
            if escape:
                escape = False
            elif c == "\\":
                escape = True
            elif c == '"':
                in_string = False
            i += 1
            continue
        if text[i] == '"':
            in_string = True
            out.append('"')
            i += 1
            continue
        if text[i] == "/" and i + 1 < n:
            if text[i + 1] == "/":
                in_line = True
                i += 2
                continue
            if text[i + 1] == "*":
                in_block = True
                i += 2
                continue
        out.append(text[i])
        i += 1
    return "".join(out)


def strip_python(text: str) -> str:
    readline = io.StringIO(text).readline
    tokens: list = []
    try:
        for tok in tokenize.generate_tokens(readline):
            if tok.type != tokenize.COMMENT:
                tokens.append(tok)
        return tokenize.untokenize(tokens)
    except (tokenize.TokenError, IndentationError):
        return text


def strip_shell_makefile(text: str) -> str:
    """Remove # line comments; naive (strings with # not handled)."""
    lines = []
    for line in text.splitlines(keepends=True):
        if line.lstrip().startswith("#!"):
            lines.append(line)
            continue
        if "SPDX-License-Identifier" in line or (
            "Copyright" in line and line.lstrip().startswith("#")
        ):
            lines.append(line)
            continue
        s = line
        in_sq = False
        in_dq = False
        out_ch: list[str] = []
        i = 0
        while i < len(s):
            c = s[i]
            if not in_sq and not in_dq and c == "#":
                break
            out_ch.append(c)
            if c == "'" and not in_dq:
                in_sq = not in_sq
            elif c == '"' and not in_sq:
                in_dq = not in_dq
            i += 1
        lines.append("".join(out_ch).rstrip() + ("\n" if line.endswith("\n") else ""))
    return "".join(lines)


EXT_HANDLERS = {
    ".py": strip_python,
    ".sv": strip_c_style,
    ".svh": strip_c_style,
    ".v": strip_c_style,
    ".vh": strip_c_style,
    ".c": strip_c_style,
    ".h": strip_c_style,
    ".cc": strip_c_style,
    ".cpp": strip_c_style,
    ".S": strip_c_style,
    ".s": strip_c_style,
    ".tcl": strip_shell_makefile,
    ".sh": strip_shell_makefile,
}

SKIP_DIRS = {
    ".git",
    "__pycache__",
    "node_modules",
    ".venv",
    "venv",
    "obj_dir",
}

SKIP_EXT = {
    ".png",
    ".jpg",
    ".jpeg",
    ".gif",
    ".pdf",
    ".bin",
    ".elf",
    ".o",
    ".a",
    ".so",
    ".dylib",
    ".woff",
    ".woff2",
    ".ttf",
    ".eot",
    ".ico",
    ".zip",
    ".tar",
    ".gz",
    ".xz",
    ".bz2",
    ".7z",
    ".rbc",
    ".memfile",
    ".vcd",
    ".fst",
}


def should_skip(path: str) -> bool:
    parts = path.split(os.sep)
    if ".git" in parts:
        return True
    _, ext = os.path.splitext(path)
    if ext in SKIP_EXT:
        return True
    return False


def process_file(path: str) -> bool:
    _, ext = os.path.splitext(path)
    base = os.path.basename(path)
    if base in ("Makefile", "makefile", "GNUmakefile"):
        handler = strip_shell_makefile
    elif ext in EXT_HANDLERS:
        handler = EXT_HANDLERS[ext]
    else:
        return False

    try:
        with open(path, "r", encoding="utf-8", errors="surrogateescape") as f:
            original = f.read()
    except OSError:
        return False

    spdx = preserve_spdx_lines(original)
    try:
        stripped = handler(original)
    except Exception:
        return False

    if spdx:
        has_spdx_out = any("SPDX-License-Identifier" in ln for ln in stripped.splitlines())
        if not has_spdx_out:
            stripped = "\n".join(spdx) + ("\n" if stripped else "") + stripped

    if stripped == original:
        return False

    try:
        with open(path, "w", encoding="utf-8", newline="") as f:
            f.write(stripped)
    except OSError as e:
        print(f"write fail {path}: {e}", file=sys.stderr)
        return False
    return True


def main() -> int:
    root = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
    changed = 0
    for dirpath, dirnames, filenames in os.walk(root):
        dirnames[:] = [d for d in dirnames if d not in SKIP_DIRS]
        for name in filenames:
            path = os.path.join(dirpath, name)
            if should_skip(path):
                continue
            if process_file(path):
                changed += 1
                print(path)
    print(f"Updated {changed} files.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
