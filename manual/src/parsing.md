# Parsing

Difftastic uses
[tree-sitter](https://tree-sitter.github.io/tree-sitter/) to build a
parse tree. The parse tree is then converted to a simpler tree which
can be diffed.

## Parsing with Tree-sitter

Difftastic relies on tree-sitter to understand syntax. You can view
the parse tree that tree-sitter produces using the `--dump-ts`
flag.

```
$ difftastic --dump-ts sample_files/before.js
{Node program (0, 0) - (7, 0)}
  {Node comment (0, 0) - (0, 8)}
  {Node expression_statement (1, 0) - (1, 6)}
    {Node call_expression (1, 0) - (1, 5)}
      {Node identifier (1, 0) - (1, 3)}
      {Node arguments (1, 3) - (1, 5)}
        {Node ( (1, 3) - (1, 4)}
        {Node ) (1, 4) - (1, 5)}
        ...
```

## Simplified Syntax

Difftastic converts the tree-sitter parse tree to a simplified syntax
tree. The syntax tree is a uniform representation where everything is
either an atom (e.g. integer literals, comments, variable names) or a
list (consisting of the open delimiter, children and the close
delimiter).

The flag `--dump-syntax` will display the syntax tree generated for a
file.

```
$ difftastic --dump-syntax sample_files/before.js
[
    Atom id:1 {
        content: "// hello",
        position: "0:0-8",
    },
    List id:2 {
        open_content: "",
        open_position: "1:0-0",
        children: [
          ...
```

### Conversion Process

The simple representation of difftastic parse tree makes diffing much
easier. Converting the detailed tree-sitter parse tree is a recursive
tree walk, treating tree-sitter leaf nodes as atoms. There are two
exceptions.

(1) Tree-sitter parse trees sometimes include unwanted structure. Some
grammars consider string literals to be a single token, whereas others
treat strings as a complex structure where the delimiters are
separate.

`tree_sitter_parser.rs` uses `atom_nodes` to mark specific tree-sitter
node names as flat atoms even if the node has children.

(2) Tree-sitter parse trees include open and closing delimiters as
tokens. A list `[1]` will have a parse tree that includes `[` and `]`
as nodes.

```
$ echo '[1]' > example.js
$ difftastic --dump-ts example.js
{Node program (0, 0) - (1, 0)}
  {Node expression_statement (0, 0) - (0, 3)}
    {Node array (0, 0) - (0, 3)}
      {Node [ (0, 0) - (0, 1)}
      {Node number (0, 1) - (0, 2)}
      {Node ] (0, 2) - (0, 3)}
```

`tree_sitter_parser.rs` uses `open_delimiter_tokens` to ensure that
`[` and `]` are used as delimiter content in the enclosing list,
rather than converitng them to atoms.

Difftastic can match up atoms that occur in different parts of the
simplified syntax tree. If e.g. a `[` is treated as an atom,
difftastic might match it with another `[` elsewhere. The resulting
diff would be unbalanced, highlighting different numbers of open and
close delimiters.

### Lossy Syntax Trees

The simplified syntax tree only stores node content and node
position. It does not store whitespace between nodes, and position is
largely ignored during diffing.
