# haskell-gi-template

THIS IS AN EXPERIMENTATION PROJECT

I just quickly wrote this to experiment with Gtk in Haskell and Template/Quasi Quotation.

# Gtk Quasi Quotation Syntax

```haskell
import GtkQuoter (gtk)

-- 

[gtk| MyWindow
      <t: text>
      <b: button>
|]
```

| Pattern        | Meaning             |
|----------------|---------------------|
| `<t: text  :>` | Text displayer      |
| `<b: label :>` | Button with label   |
| `<?: label :>` | Checkbox with label |
