; Functions

(call_expression
  function: (scoped_identifier
    name: (identifier) @function))

(template_function
  name: (identifier) @function)

(template_method
  name: (field_identifier) @function)

(template_function
  name: (scoped_identifier
    name: (identifier) @function))

(function_declarator
  declarator: (scoped_identifier
    name: (identifier) @function))

(function_declarator
  declarator: (scoped_identifier
    name: (identifier) @function))

(function_declarator
  declarator: (field_identifier) @function)

; Types

((namespace_identifier) @type
 (#match? @type "^[A-Z]"))

(auto) @type

; Constants

(this) @variable.builtin
(nullptr) @constant

; Keywords

"catch" @keyword
"class" @keyword
"co_await" @keyword
"co_return" @keyword
"co_yield" @keyword
"constexpr" @keyword
"delete" @keyword
"explicit" @keyword
"final" @keyword
"friend" @keyword
"mutable" @keyword
"namespace" @keyword
"noexcept" @keyword
"new" @keyword
"override" @keyword
"private" @keyword
"protected" @keyword
"public" @keyword
"template" @keyword
"throw" @keyword
"try" @keyword
"typename" @keyword
"using" @keyword
"virtual" @keyword

; Strings

(raw_string_literal) @string
