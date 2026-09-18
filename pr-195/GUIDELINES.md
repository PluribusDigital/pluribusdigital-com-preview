# Guidelines for PluribusDigital.com

## Voice

We convey a straightforward, authentic voice. Use plain language. Avoid jargon.

See the [Pluribus Brand Voice](https://github.com/PluribusDigital/playbook/blob/main/branding/guide.md) documentation for details.

For the web site in particular text should be scannable (use of lists, emphasized headings, recognizable hyperlinks). Hyperlink text should be meaningful when taken out of context (no "click here"). This helps accessibility (because users may tab through links) and scannability (links are a form of emphasis and a queue for more information).

## Style

We are producing information to be found and read. Keep the visuals clean, legible, high-contrast. Do use styling for true content emphasis and visual appeal. The web is meant to house documents, so think of each page as something that is readable top to bottom, but also scannable to quickly find information.

* Avoid animations or other interaction effects that are not important to the information or interaction.
* Follow established conventions (e.g., underlined hyperlinks).
* Use gradients or other background/texture graphics minimally, and only for specific areas of the site; never when the background for a substantial body of text.
* Let the content be the star.
* Do use real photos and custom illustration relevant to to the content. Images should have some value and authentic connection. Avoid stock photos. Do not use AI-generated images.

## Technology

The below all boil down to using HTML properly and keeping things simple. These fundamentals make accessibility, page load, and usability far easier. See also: [brutalist-web.design](https://brutalist-web.design/).

### Accessibility

We cannot break the accessibility and usability for those dependent on screen readers or other assistive technology. The site should be usable.

The site must render well on mobile browsers. This also helps with desktop browser windows that are sized to a small width or at a high zoom level.

### Code (HTML, CSS, Javascript)

The web is meant for documents. HTML should be clean and follow good practice. Specific examples of "good":

* HTML tags follow proper semantics (lists are lists, paragraphs are paragraphs, footers are footers, etc.).
* HTML is not bloated with excessive nested DIV tags.
* HTML should be readable as source code.
* Maintain reasonable print styles.
* Be sparing with javascript.
* Don't subvert normal browser behavior (getting cute with scrolling effects or back button interactions that don't make sense).
* The site can render without stylesheets or javascript.
* The site should have great lighthouse scores.
* Minimize page load through techniques like paring down javascript or CSS libraries to only the used components (e.g., using the purgecss library when building).
* URLS and paths are part of the user interface. They should be logical and clearly worded.

### Compromises

In some cases it may not be practical for all content to adhere perfectly to all of the above. We cannot fundamentally break accessibility, but we can make other reasonable compromises. For example, integrating a 3rd party job board requires some violations of the above goals, but it would be impractical to fully solve that.