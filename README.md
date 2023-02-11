# Nameref Extension For Quarto

A Quarto filter extension that allows to refer to section (like what latex package [`\nameref`](https://mirror.las.iastate.edu/tex-archive/macros/latex/contrib/hyperref/doc/nameref.pdf) does), figure, image using a text/name instead of section number or plain `Figure #` or `Table #`. This filter works for both format `html` and `pdf`.

## Installing

*Note that, it is [recommended](https://quarto.org/docs/extensions/) to use a quarto version at least 1.2 to work with extensions.*

```bash
quarto add shafayetShafee/nameref
```

This will install the extension under the `_extensions` subdirectory.
If you're using version control, you will want to check in this directory.

## Using

### Refer to a section using the text of the section header

To refer to a section, add an identifier, suppose `#how`, to header and use `\nameref{how}` to reference that section.

```
## Why Quarto is so great {#how}

See \nameref{how}.
```

And in rendered document this looks like,

![section-reference](images/section_nameref.png)

### Refer to code chunk generated plot or table

To name refer a plot or table generated from table, use the chunk option `link-id` that works as identifier and `link-title` that works as the reference text.

````
```{r}
#| link-id: fig1
#| link-title: My Awesome plot

plot(1:10)
```

See \nameref{fig1}.

````

which looks like,

![](images/chunk_nameref.png)


Note that, `nameref` does not interfere with [Quarto's way](https://quarto.org/docs/authoring/cross-references.html#overview) of cross-referencing. You can use `label` and `fig-cap` to refer to this plot in usual way.


### Refer to image or table written in markdown syntax

To use `nameref` for [markdown images](https://quarto.org/docs/authoring/figures.html#figure-basics) or for [markdown tables](https://quarto.org/docs/authoring/tables.html#markdown-tables), wrap the image or table with [Divs](https://quarto.org/docs/authoring/markdown-basics.html#divs-and-spans) (`:::`) with class `link` and `link-id`, `link-title` attributes.

````
::: {.link link-id="fig2" link-title="Scatter plot"}

![mpg ~ hp](images/mpg.png)

:::

See \nameref{fig2}.

````

````
::: {.link link-id="tab2" link-title="Markdown table"}

| Col1 | Col2 | Col3 |
|------|------|------|
| A    | B    | C    |
| E    | F    | G    |
| A    | G    | G    |

: My Caption {#tbl-tab2}

:::

See \nameref{tab2}.

````

And this looks like, 

![](images/md_nameref.png)


## Demo

Here is the source code for a example: [example.qmd](example.qmd), containing the above all examples together in one place and the [live demo](https://shafayetshafee.github.io/nameref/example.html) of the rendered document in HTML output format. Also to see how `nameref` looks like in pdf format, [download](https://github.com/shafayetShafee/nameref/raw/main/docs/example.pdf) the rendered pdf output of `example.qmd` file.

## Numbered nameref

It is also possible to use section number, figure or table number with the named reference. 

### using section number with section nameref

To get numbered section nameref, we need to do couple of things.

- Firstly, use Quarto option `number-sections: true`
- Secondly, use the `quarto` filter before the `nameref` filter (so that `nameref` can use the section number generated by `quarto` filter).
- Lastly, use `section-number: true` under option `nameref`.

````
---
title: "Using nameref"
number-sections: true
filters: 
  - quarto
  - nameref
nameref:
  section-number: true
---

# Why Quarto is so great {#sec-stack}

See \nameref{sec-stack}.


## Why Quarto is so great {#how}

See \nameref{how}.
````

and the rendered output is,

![](images/numbered_section.png)


### using figure and table number with nameref

This filter provides no direct support to do this. But you can try a naive approach by using `@fig-id \nameref{id}` together :wink:.

### Demo

[View a live demo of numbered `nameref`](https://shafayetshafee.github.io/nameref/numbered_example_html.html) of the rendered document in HTML output format and the source code [numbered_example_html.qmd](numbered_example_html.qmd)

Also to see how numbered `nameref` looks like in pdf format, [download](https://github.com/shafayetShafee/nameref/raw/main/docs/numbered_example.pdf) the rendered pdf output of [numbered_example.qmd](numbered_example.qmd) file.


## Limitations

This filter does not work across chapters of Book for now. It works within a chapter but does not across, that is, you can not `nameref` a section (or image/table) in one chapter from another chapter. This is because, as per my knowledge, quarto filter applies to each chapter qmd file separately and I do not know how to make it work for all chapter qmd files at once. So if anybody knows this, [please let me know](https://github.com/shafayetShafee/nameref/pulls).

