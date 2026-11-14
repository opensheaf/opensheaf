<TeXmacs|2.1.5>

<style|<tuple|notes|notes-meta>>

<\body>
  <notes-header>

  <chapter*|OpenSheaf: frequently asked questions>

  <notes-abstract|Answers to questions that come up about the design of <hlink|OpenSheaf|https://opensheaf.org>. The specification (<hlink|opensheaf-specification-0.1.md|opensheaf-specification-0.1.tm>) is authoritative; this page explains its choices.>

  <section*|What is OpenSheaf for?><label|what-is-opensheaf-for>

  It is an open format for archives of scholarly documents and for collections of them: a lean alternative to arXiv and to the usual publication infrastructure. Anyone can keep an archive of their documents as plain files on a static website, with sources, versions fixed by hashes, standard metadata, and collections that combine documents from several archives.

  <section*|Why not just use arXiv, or Zenodo?><label|why-not-just-use-arxiv-or-zenodo>

  Both are excellent services, and OpenSheaf works with them: a document can also be on arXiv (linked with <verbatim|IsIdenticalTo>), and the Zenodo binding gives every version a DOI on Zenodo. What OpenSheaf adds is an archive that its owner keeps and controls, that stores sources (not only PDFs) in a documented layout, that anyone can verify file by file, and that can be combined with other archives into collections and selections without asking any central service.

  <section*|Do I need Zenodo, TeXmacs, git or GitHub?><label|do-i-need-zenodo-texmacs-git-or-github>

  No. The core of the format is an OCFL storage root and a discovery document served over HTTPS. Zenodo, TeXmacs and the website are optional profiles (appendices A, B and C). Git and GitHub Pages are convenient ways to keep and serve an archive, but any static web server will do.

  <section*|Why OCFL? Isn't git enough?><label|why-ocfl-isnt-git-enough>

  Git records history, but its layout is internal to git and its hashes (SHA-1 in most repositories) are not meant for long-term preservation. OCFL (the Oxford Common File Layout) is a published specification for exactly this problem: versioned objects stored as plain files, every file fixed by a SHA-512 digest, readable without any special software, with independent validators, used by research libraries. An OpenSheaf archive can still be kept in git; git just is not part of its integrity.

  <section*|Why DataCite metadata, and not RO-Crate, Dublin Core or JATS?><label|why-datacite-metadata-and-not-ro-crate-dublin-core-or-jats>

  DataCite is the metadata behind DOIs for repositories (Zenodo, arXiv's DOIs, university repositories). It has the relations needed here (versions, preprints and published articles, collections), it maps directly to Zenodo, and its records are harvested by ORCID, OpenAlex and search services. RO-Crate is richer but heavier; Dublin Core is too thin; JATS is for the full text of journal articles.

  <section*|Why JSON and not YAML?><label|why-json-and-not-yaml>

  The metadata files are written by tools and checked by machines. JSON is strict, has one way of writing each value, and is read everywhere without extra libraries. YAML is nicer to edit by hand but converts values silently (dates, version numbers like <verbatim|1.10>, identifiers like <verbatim|2611.14296>).

  <section*|Why is there a discovery document (opensheaf.json)?><label|why-is-there-a-discovery-document-opensheafjson>

  Static web servers cannot list folders, so a program visiting an archive could not find its objects. <verbatim|opensheaf.json>, at the archive's address, lists them with their head versions and digests, names the storage root and the main collection, and says which version of the specification the archive follows. It is only a map: everything it says is checked against the storage root.

  <section*|Why are identifiers short names and not URIs?><label|why-are-identifiers-short-names-and-not-uris>

  The flat-direct storage layout puts each object in a folder named by its identifier, so paths stay readable and can be computed over plain HTTP; a folder name cannot contain <verbatim|/>. The archive itself has a URI-like identifier (a <verbatim|tag:> URI, for instance <verbatim|tag:opensheaf.org,2026:mgubi>), and an object is named globally by the pair (archive identifier, object identifier).

  <section*|What is the difference between a document version and an object version?><label|what-is-the-difference-between-a-document-version-and-an-object-version>

  The document version is the version of the work, what readers see and what gets a DOI: it changes only when the document's own files change (sources, renditions, change note). The object version (<verbatim|v1>, <verbatim|v2>, ...) is OCFL's: it changes at every change of the object, including corrections of the description (adding the DOI of the journal version, fixing an affiliation) and notices about earlier versions.

  <section*|How are versions numbered and ordered?><label|how-are-versions-numbered-and-ordered>

  The archive numbers document versions itself, from 1 and without gaps, even when an external service numbers them differently: if arXiv still serves only v1, v3 and v4 of a paper, they are document versions 1, 2 and 3, and the arXiv labels are recorded beside them. Versions are normally in the order of their numbers. When an earlier version turns up later, it gets the next number and an explicit <verbatim|history> in <verbatim|object.json> puts it in its place; the current version, the one readers are directed to, is the last in the history. Dates are only information: they may be approximate or unknown, so they never decide the order.

  <section*|What if a version turns out to be wrong?><label|what-if-a-version-turns-out-to-be-wrong>

  Deposit a corrected version, with a change note saying what changed. To warn readers of the earlier version, add a notice about it (for instance an erratum, as text or as a file): notices are later statements about a version, kept with the object and shown with that version, and they never change the version itself.

  <section*|How do collections work across archives? What if another archive disappears?><label|how-do-collections-work-across-archives-what-if-another-archive-disappears>

  A collection lists its members by archive identifier, address, object identifier, version and the SHA-512 digest of that version's inventory (the "pin"). Since an inventory fixes all its files, the pin fixes the member completely, and a collection becomes a hash tree over everything it contains. If the member's archive moves or disappears, the member can be fetched from a mirror, from its DOI deposit or from a Software Heritage snapshot: any copy that matches the pin is the right one. A collection also keeps a cached citation of each member, so that it stays readable even if no copy is found.

  <section*|Why both archives and collections?><label|why-both-archives-and-collections>

  They answer different questions. An <strong|archive> is custody and naming: one owner's storage root and discovery document, under an archive identifier. It says who keeps an object, what it is called, and where its files are. An object is named by the pair (archive identifier, object identifier), and its versions are added only by its archive, which is its single writer: a copy kept elsewhere (a mirror) stays the object of its archive and can only receive its versions. Archives do not overlap and do not nest. (Under a proposal, below, the single writer is the owner of a line, and the archive is only where the line is kept: see "Who owns an object, and what is a branch?")

  A <strong|collection> is a statement: a versioned list of pins, made by a curator, over objects of any archives. It says which objects, in which versions, go together: an author's papers, an issue of a journal, a reading list. Collections are objects themselves, so they can be pinned, nested and included in other collections, across archives.

  The two are kept apart because an archive changes at every deposit and holds facts that are nobody's claim (which objects it holds, their heads, mirrors, tombstones, keys), while a collection changes by the rules its curator set (adding members, following them as they grow, vetting their versions), and each of its versions can be cited and verified as it stood. When an archive itself should be cited as it stood, that is what its main collection is for: a catalogue of its own documents, pinned like any other. Archives partition the objects, each object having one home; collections overlay them, any number of views over any homes.

  <section*|What is the difference between a catalogue and a selection?><label|what-is-the-difference-between-a-catalogue-and-a-selection>

  Keeping and vetting are different acts, and OpenSheaf has a kind of collection for each. A <strong|catalogue> keeps objects whole and is impartial about their versions: each member pins an object with all its versions, and the collection may follow it as its owner adds versions. An author's archive, an institution's repository and a storage site list what they keep in catalogues. A <strong|selection> vets particular revisions: a journal its accepted version, a digest or a review journal the version it read. Each member pins the revision set that was vetted; later versions by the authors are not part of it, and any change of what is vetted (a correction accepted by the editors) is an explicit act of the curator, recorded as a new version of the selection. The <hlink|use cases|use-cases.tm> show both at work.

  <section*|Can I put someone else's paper in my collection?><label|can-i-put-someone-elses-paper-in-my-collection>

  Yes. A reference (a pin) copies nothing and needs no permission. There are two ways to keep a copy, both allowed only if the licence of what is copied permits redistribution (or the authors agree): a <strong|mirror> copies the whole object, every version, and stays the original archive's object (for an institution or a storage site); an <strong|accepted copy> takes the one revision a selection vetted into the selection's own archive, where later changes are the curator's acts (for a journal). The licence of a collection (CC0 for the list) never extends to its members.

  <section*|Who owns an object, and what is a branch?><label|who-owns-an-object-and-what-is-a-branch>

  <os-alert|note|Note.|This answer describes a proposal (section 6.5 and 10.5 of the specification, on the branch <verbatim|proposal/identity>), not yet agreed.>

  An object has a <dfn|name>, the digest of the genesis record written when it is first made available, and an <dfn|owner>, the one who decides its versions. The pair (owner, name) identifies a <dfn|line>: one history, with a single writer. The archive that keeps the object is only where it lives: mirrors keep the same line elsewhere.

  The owner can be light or strong. A draft has none. A named owner is a URI the owner asserts (an archive identifier, an ORCID iD, a web address): enough for most authors. A keyed owner is a public key: every version is signed, so the line can be checked even when its archive has gone.

  Anyone can copy a genesis record, so the name alone cannot say whose history is the right one. That is why the owner is part of the identity: a copy kept by another owner is a <dfn|branch>, which declares the version it starts from. A <strong|deep> branch copies all earlier versions and continues them (a co-author carrying the work on). A <strong|shallow> branch keeps only the version it starts from, with the parent's inventory and <verbatim|object.json> as evidence, and adds its own versions (a journal keeping the version it vetted, then its corrections). An accepted copy is a shallow branch kept by a selection.

  A shallow branch can be checked without its parent: the genesis record gives the name, the copied inventory gives the parent pin, the files match that inventory, and the copied <verbatim|object.json> says whose version it was. This shows only that the branch is consistent. Whether the parent's owner really made that version is confirmed by resolving the parent, by the parent owner's signature, or by other witnesses; failing these, it rests on the branch owner's word.

  <section*|Can documents be linked in richer ways (a short account and its full proof)?><label|can-documents-be-linked-in-richer-ways-a-short-account-and-its-full-proof>

  Yes, on top of the format rather than in it. The core keeps only what every archive needs to keep, cite, compose and verify documents. Other relations are built from it: by links inside the documents and DataCite relations, which need nothing more, or by <strong|extensions> (section 4 of the specification), published separately, whose data an object version records in its <verbatim|object.json>, so that tools that know them can follow the relation when they copy, verify or present documents. Extensions never change the core: an archive is read and verified without them. The <hlink|use cases|use-cases.tm> show a journal publishing a short account of a proof whose detailed argument, possibly written with AI, stays online in the version reviewed.

  <section*|Where do signatures and timestamps go, and why not in the version itself?><label|where-do-signatures-and-timestamps-go-and-why-not-in-the-version-itself>

  A signature or timestamp of an object version can only be made after the version is committed, so it cannot be part of that version: a signature of an inventory cannot be listed in the inventory it signs. Making a new version for each signature would mix evidence with changes of the work, and every upgrade of a timestamp proof (OpenTimestamps proofs are completed once their attestation is confirmed) would be another version.

  OCFL does not allow arbitrary files in an object folder; its <verbatim|logs/> folder is meant for unstructured records of actions and is not covered by digests. The place OCFL provides for data that is not part of any version is the object's <verbatim|extensions/> folder (the registered mutable-head extension keeps its data there). So OpenSheaf puts witnesses in <verbatim|extensions/opensheaf-witnesses/>, where they travel with the object. An archive that never touches object folders after commit may keep them in a <verbatim|witnesses/> folder outside the storage root instead. Witnesses need no digests of their own: each one is checked directly against the checksum file it names, which the pins fix.

  <section*|Why is the HTML version not part of the deposit?><label|why-is-the-html-version-not-part-of-the-deposit>

  Because presentations improve (stylesheets, exporters, fixes) and deposits must not change. The deposit keeps the sources and the PDF; the HTML is regenerated from the sources whenever the presentation changes.

  <section*|How do I withdraw or take down a document?><label|how-do-i-withdraw-or-take-down-a-document>

  To withdraw a document (for instance a retraction), make a new version with a withdrawal notice: the content and its history stay, and presentations show the notice. If content must be removed (by law, or for a breach of rights), the object is deleted and a tombstone is left in the discovery document, so that collections pinning it report it as removed rather than corrupt. OCFL version 2 is expected to add a native mechanism for deleting single files; OpenSheaf will adopt it when it is published.

  <section*|Can I use "All rights reserved"?><label|can-i-use-all-rights-reserved>

  Yes. Each document carries the licence its authors choose; "All rights reserved" means readers may access the document but not reuse it. The metadata (descriptions, object records, member lists, inventories) is CC0, so that it can be harvested and mirrored freely. On Zenodo, "All rights reserved" is entered as a custom licence.

  <section*|Will Google Scholar find the papers?><label|will-google-scholar-find-the-papers>

  If the archive follows the website profile: each document then has a landing page with the <verbatim|citation_*> meta tags Google Scholar reads, and a PDF on the same host. Appendix C also recommends a sitemap and FAIR Signposting links.

  <section*|How do I check an archive?><label|how-do-i-check-an-archive>

  A verifier validates the JSON files against the schemas in <hlink|schemas/|schemas/>, validates the storage root with a standard OCFL validator (such as <verbatim|ocfl-py>), checks that the discovery document matches the storage root, and resolves and checks every member of every collection. The specification (section 14) lists the checks.

  <section*|Is the format stable?><label|is-the-format-stable>

  Not yet: version 0.1 is a draft, and versions before 1.0 may change in incompatible ways. Every file declares the version of the format it follows, so that tools can tell. From version 1.0, minor versions will be backward compatible.

  <section*|Why the name?><label|why-the-name>

  A sheaf is a bundle of papers. In mathematics, a sheaf is the structure in which local pieces glue into a whole: archives kept and verified separately compose into collections.

</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>
