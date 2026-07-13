# {{title}}

**Citekey::** {{citekey}}
**Title::** {{title}}
**Authors::** {% for creator in creators %}{{creator.firstName}} {{creator.lastName}}{% if not loop.last %}, {% endif %}{% endfor %}
**Year::** {{date | format("YYYY")}}
**Publication::** {% if publicationTitle %}{{publicationTitle}}{% elif publisher %}{{publisher}}{% endif %}
**URL::** {% if DOI %}[https://doi.org/{{DOI}}{%](https://doi.org/{{DOI}}{%) else %}{{url}}{% endif %}



Zotero PDF Link: {{pdfZoteroLink}}  
Related:: {% for relation in relations | selectattr("citekey") %} [{{relation.citekey}}]({{relation.citekey}}){% if not loop.last %}, {% endif%} {% endfor %}

## Abstract

{{abstractNote}}

## Reading Notes

{% for annotation in annotations -%}
{% if annotation.annotatedText -%}

> {{annotation.annotatedText}}
> {% endif -%}
> {% if annotation.comment -%}
> **Note:** {{annotation.comment}}
> {% endif -%}

{% endfor -%}

## Relevance to Thesis

