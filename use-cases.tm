<TeXmacs|2.1.5>

<style|<tuple|notes|notes-meta>>

<\body>
  <notes-header>

  <chapter*|OpenSheaf: use cases>

  How the <hlink|specification|opensheaf-specification-0.1.tm> adapts to the people and institutions that keep and select scholarly documents. It is non-normative: where it and the specification differ, the specification holds. Commands of the reference tools, <hlink|opensheaf-py|https://github.com/opensheaf/opensheaf-py> (<verbatim|osheaf>), are given as illustrations; any tool following the specification will do.

  Three roles recur:

  <\itemize>
    <item><hlink|<dfn|authors>|#authors> make documents and their versions;

    <item><hlink|<dfn|archives>|#archives> keep documents, every version, impartially: an author's own archive, an institution's repository, an independent storage site;

    <item><hlink|<dfn|selections>|#selections> vet particular versions (revisions) of documents: a journal, a digest, a review journal, a reading list, proceedings.
  </itemize>

  Archives list what they keep in <dfn|catalogues>, which pin objects whole and may follow them as they grow; selections are the other kind of collection of section 10, which pins revision sets and changes only by an act of its curator. Copies are of two kinds too: a <dfn|mirror> copies a whole object (an archive keeping another archive's objects), an <dfn|accepted copy> takes one vetted revision into the selection's own archive. Collections and copies only concern documents kept in OpenSheaf archives: a paper that exists only on arXiv or on a publisher's site is first deposited in an archive (for instance imported from arXiv into its author's archive) before it can be pinned.

  <section*|Authors><label|authors>

  <subsection*|A researcher's own archive><label|a-researchers-own-archive>

  A mathematician keeps an archive of her papers on her website (the first archive, <hlink|mgubi.org/papers|https://mgubi.org/papers/>, is one).

  <\itemize>
    <item>Each paper is a document object; each version of the paper, a document version, numbered by the archive from 1 without gaps. Versions imported from arXiv keep arXiv's label (<verbatim|v3>) in <verbatim|external>.

    <item>A version that arXiv keeps only as a PDF is deposited without sources (<verbatim|sourcesMissing>); when she finds the sources, they complete that same version (section 7.3).

    <item>A draft or a submitted manuscript found later is deposited in its place in the history (<verbatim|history>), without renumbering what exists; versions never public at the time carry a <verbatim|Created> date, and their <verbatim|Available> date is the date of their deposit.

    <item>An erratum is a notice about a version; a retraction is a withdrawal. Both are description-only versions: nothing deposited changes.

    <item>The archive's main collection is a <strong|catalogue> of her own documents, following them: the index shows the current version of each.

    <item>DOIs come from the Zenodo binding (appendix A): a concept DOI for each document and a DOI for each document version. A version deposited out of order may be deposited as a separate Zenodo record, and notices are not uploaded, since the files of a published Zenodo record are fixed.
  </itemize>

  <\html-div-class|language-bash>
  <\verbatim-code>
    # deposit a new paper: its LaTeX source, the files it includes, and the PDF

    osheaf deposit kpz-uniqueness paper.tex \\

    \ \ --pdf paper.pdf \\

    \ \ --extra-source refs.bib \\

    \ \ --extra-source figures/fixed-point.pdf=figures/fixed-point.pdf \\

    \ \ --title "Uniqueness of the KPZ fixed point" \\

    \ \ --author "Doe, Jane\|University of Example" \\

    \ \ --rights cc-by-4.0 \\

    \ \ --stage AO



    # a second version, revised after the referees' comments and accepted

    # (the title, the authors and the licence are given again for each version)

    osheaf deposit kpz-uniqueness paper.tex \\

    \ \ --pdf paper.pdf \\

    \ \ --extra-source refs.bib \\

    \ \ --extra-source figures/fixed-point.pdf=figures/fixed-point.pdf \\

    \ \ --title "Uniqueness of the KPZ fixed point" \\

    \ \ --author "Doe, Jane\|University of Example" \\

    \ \ --rights cc-by-4.0 \\

    \ \ --changes "Corrected the proof of Lemma 3; new appendix." \\

    \ \ --stage AM



    # an erratum about version 1, which stays as it was deposited

    osheaf notice kpz-uniqueness \\

    \ \ --about 1 \\

    \ \ --text "Lemma 3 is wrong as stated; corrected in version 2."



    # papers on arXiv: download them (downloads/ is created; identifiers.json

    # in it maps arXiv identifiers to object identifiers), then import the new

    # versions of papers already in the archive

    osheaf arxiv fetch downloads --refresh

    osheaf arxiv import downloads --update



    # update the main collection and the website, then check everything

    osheaf collect

    osheaf index

    osheaf verify
  </verbatim-code>
  </html-div-class>

  <subsection*|Co-authors in different archives><label|co-authors-in-different-archives>

  Two co-authors each keep an archive; their joint paper is deposited once, in one of them. The other lists it in a collection of her own archive (for instance "papers with my students") as a member of another archive. In an <strong|catalogue> with <verbatim|follow>, each time she updates the collection (<verbatim|osheaf collect>) it pins the head of her co-author's object, its newest object version; nothing is copied, and no permission is needed. Her member entry can list in <verbatim|mirrors> the archives that mirror the paper (section 10.2), so that readers still reach it when her co-author's archive is down. If she wants the paper in her archive too, and the licences of all its versions allow redistribution, she can <strong|mirror> it: a byte-for-byte copy of the whole object, which stays the co-author's object (<verbatim|mirrorOf>).

  <subsection*|A research group, a seminar, lecture notes><label|a-research-group-a-seminar-lecture-notes>

  A group keeps one archive for its members' papers, theses and slides, or each researcher keeps her own and the group keeps a catalogue whose members are documents of those archives. Lecture notes and slides are documents like papers (<verbatim|resourceTypeGeneral> <verbatim|Text>, with <verbatim|resourceType> "Lecture notes", or <verbatim|Presentation> for slides); notes revised every year are versions of one document, or separate documents when an edition is a different work (a new title, a different course).

  <section*|Archives><label|archives>

  <subsection*|An institutional repository><label|an-institutional-repository>

  A university keeps an archive of its members' work.

  <\itemize>
    <item>Members may deposit directly in the institution's archive, whose main collection is a catalogue of its documents, perhaps with one catalogue per department.

    <item>Or members keep their own archives, and the institution <strong|mirrors> their documents: each mirror is a whole copy, every version, kept up to date by copying new versions, and listed with <verbatim|mirrorOf> in the institution's discovery document. Mirroring is allowed only when the licences of all the versions copied allow redistribution (section 10.4). Many papers imported from arXiv carry arXiv's default licence, which does not; the institution then only references them, or asks the authors to deposit openly licensed versions.

    <item>The institution is impartial: it keeps what its members deposit. It does not vet versions; that is what selections do.
  </itemize>

  <subsection*|An independent storage site><label|an-independent-storage-site>

  A preservation service (a library, a consortium) keeps copies of archives so that they survive their owners' servers.

  <\itemize>
    <item>It mirrors whole archives, or chosen objects of them, byte for byte. An archive mirrored entirely can list the copy in the <verbatim|mirrors> of its discovery document, which helps as long as that document can be reached; collections that should survive an archive's disappearance list mirrors in their members' entries (section 10.2), which clients try when the archive fails (section 6.4).

    <item>Since every collection pins its members by digest, any copy whose bytes match is as good as the original: integrity comes from the pin, not from the place. Verifiers check mirrors exactly as originals.

    <item>Further witnesses that a version existed, with these bytes, at a date: signatures and timestamps (section 13.2), made by the authors or by others; a snapshot of the archive's git repository by Software Heritage, cited by its SWHID (section 8.1); and Zenodo deposits (appendix A), which keep the content files, though without the inventory a Zenodo record cannot be checked against a pin.
  </itemize>

  <\html-div-class|language-bash>
  <\verbatim-code>
    # copy an object of another archive, byte for byte, with all its versions

    osheaf mirror https://example.org/papers/ kpz-uniqueness



    # list it in a collection of the archive, so that the website shows it and

    # verify checks it (preserved.yaml below; "mirror: yes" copies and lists

    # in one step)

    osheaf collection sync preserved --from preserved.yaml



    # write the discovery document and the website, then check the archive;

    # members of other archives are checked too, on their mirrors when their

    # own archive does not answer

    osheaf index

    osheaf verify --remote
  </verbatim-code>
  </html-div-class>

  <\html-div-class|language-yaml>
  <\verbatim-code>
    id: preserved

    title: Papers preserved by the library

    type: catalogue

    members:

    \ \ - archive: https://example.org/papers/ \ \ # the base URL (archiveUrl in members.json)

    \ \ \ \ id: kpz-uniqueness

    \ \ \ \ mirror: yes
  </verbatim-code>
  </html-div-class>

  <subsection*|An archive that moves><label|an-archive-that-moves>

  An author moves her archive to a new domain. Its archive identifier (a <verbatim|tag:> URI) does not change. Collections recorded the base URL of the time (<verbatim|archiveUrl>): readers still reach the archive through HTTP redirects from the old address, which she should keep as long as she can, or through the mirrors listed in member entries; curators update <verbatim|archiveUrl> in a new version of their collections. Pins stay valid, because they fix bytes, not addresses.

  <section*|Selections><label|selections>

  <subsection*|An overlay journal><label|an-overlay-journal>

  A journal whose papers are kept by their authors in OpenSheaf archives (a paper only on arXiv is first imported into an archive, its author's or the journal's, with arXiv recorded as its source) accepts, after review, a particular version of each paper.

  <\itemize>
    <item>An issue is a <strong|selection>: each member pins the revision set the editors vetted, usually the accepted version.

    <item>The authors' later versions are not in the issue: they have not been reviewed. A correction accepted by the editors adds a revision to the set, as a new version of the issue, recorded in its inventory as the editors' act.

    <item>To make sure what it vetted stays available, the journal keeps an <strong|accepted copy> of each vetted revision, as a document of its own archive: exactly the files of that version, byte for byte, with the source and its pin recorded. Only the copied revision needs a licence allowing redistribution; a paper whose first preprint was under a restrictive licence can be accepted in a later, openly licensed version. Later versions of the accepted copy (corrections, notices, a withdrawal) are the editors' acts; the authors' archive cannot change them.
  </itemize>

  <\html-div-class|language-bash>
  <\verbatim-code>
    # keep an accepted copy of the version the editors vetted; --version names

    # the object version vetted (vN in the authors' storage), not the document

    # version

    osheaf accept https://authors.example.org/ network-discrimination \\

    \ \ --version v2 \\

    \ \ --stage VoR \\

    \ \ --agreement "the journal's publication terms"



    # list the issue (issue-7.yaml below): a selection, whose member pins the

    # revisions vetted; update never changes them, it only reports versions

    # not vetted. Name the collection: without a name, sync replaces the main

    # collection.

    osheaf collection sync issue-7 --from issue-7.yaml
  </verbatim-code>
  </html-div-class>

  <\html-div-class|language-yaml>
  <\verbatim-code>
    id: issue-7

    title: Issue 7

    type: selection

    members:

    \ \ - archive: "." \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ # the accepted copy, in the journal's archive

    \ \ \ \ id: network-discrimination

    \ \ \ \ revisions: [1] \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ # its document version 1; after a correction, [1, 2]
  </verbatim-code>
  </html-div-class>

  <subsection*|A journal that publishes its own version><label|a-journal-that-publishes-its-own-version>

  A journal typesets the accepted paper in its own layout, gives it a DOI, and publishes it under its licence, with the authors' agreement.

  <\itemize>
    <item>The journal's version of record is a document of the journal's archive, not a version of the authors' document (section 7.3): it has the journal as <verbatim|publisher>, its DOI in <verbatim|doi>, <verbatim|stage> <verbatim|VoR>, the journal's <verbatim|rightsList>, the authors' agreement in <verbatim|object.json>, and a relation to the authors' version it was made from (<verbatim|IsVariantFormOf>: the same work in another form, section 8.1).

    <item>The authors' preprint is linked to it by a description-only version of their own document (<verbatim|IsVersionOf> the article's DOI, section 8.1), if they want.

    <item>The journal's issues are selections of its own documents, or catalogues of them: the journal's own documents change only by its own acts in either case.
  </itemize>

  <subsection*|A short account of a proof, with its detailed argument><label|a-short-account-of-a-proof-with-its-detailed-argument>

  A mathematician proves a theorem and writes two documents, both in her own archive: a <dfn|short account>, written to explain how the argument works (the idea, the structure of the proof, where the difficulty lies), and the <dfn|detailed argument>, every step written out, possibly largely produced with an AI system, possibly with a formal proof beside it. A journal reviews both, in particular versions, and publishes only the short account; the detailed argument stays online, in the version reviewed, open to scrutiny and to analysis by people and machines.

  <\itemize>
    <item><strong|Two documents, not one.> Each has its own versions, licence and history: the detailed argument may change often (a gap closed, a step expanded after a machine check) while the account stays as it is. Each is a document object of her archive (say <verbatim|kpz-account> and <verbatim|kpz-details>). The detailed argument says how it was made in its <verbatim|datacite.json> (a description of type <verbatim|Methods>: the AI system and its version, what the authors checked and how), and lists in its <verbatim|toolchain> the tools needed to rebuild it and its formal checks; its creators are the persons who answer for it.

    <item><strong|The account focuses on the detailed argument.> The core of the format has no relation of this kind, and needs none: the link is made from inside. The account cites, in its text, the exact object version of the detailed argument (its URL, <verbatim|.../ocfl/kpz-details/v3/>, and the digest of its inventory), and its <verbatim|datacite.json> links that URL with <verbatim|IsSupplementedBy>; the detailed argument may link back with <verbatim|IsSupplementTo>, added by a description-only version. Since the digest is in the account's own files, a pin of the account fixes the detailed argument too: the hash tree goes on through the link, though only readers, and tools that read the text, see it.

    <item><strong|The journal vets the pair.> Its issue is a <strong|selection> whose member is the account: an accepted copy of the vetted revision, or the journal's own version of record made from it. The detailed argument is not published by the journal, but the version it reviewed is fixed by the account's pin. So that plain verifiers check it as well, the journal may keep a second selection beside the issue (say <verbatim|issue-7-details>), pinning the revisions of the detailed arguments it reviewed.

    <item><strong|The detailed argument stays available.> Her archive keeps it, with all its versions. To make sure the version reviewed survives her server, the journal, or a storage site, <strong|mirrors> the detailed argument, if its licences allow: a mirror is the authors' object, impartial, every version, which is what the journal wants for a document it vetted but does not publish (an accepted copy would make it a document of the journal). The selection <verbatim|issue-7-details> lists the mirror in its member's <verbatim|mirrors>; a Software Heritage snapshot of her archive is a further witness.

    <item><strong|Later versions.> When she improves the detailed argument after publication, her catalogue follows it; the account published by the journal keeps pointing to the version reviewed, and presentations may say that later, unreviewed versions exist. If scrutiny finds an error, the journal adds a notice to its accepted copy, or vets a corrected pair, as a new version of the issue.
  </itemize>

  <\html-div-class|language-bash>
  <\verbatim-code>
    # the journal keeps an accepted copy of the account, mirrors the detailed

    # argument, and lists both in selections (issue-7.yaml, issue-7-details.yaml)

    osheaf accept https://authors.example.org/ kpz-account --version v2 --stage VoR \\

    \ \ --agreement "the journal's publication terms"

    osheaf mirror https://authors.example.org/ kpz-details

    osheaf collection sync issue-7 --from issue-7.yaml

    osheaf collection sync issue-7-details --from issue-7-details.yaml
  </verbatim-code>
  </html-div-class>

  <strong|With an extension.> Linking from inside asks nothing of the format, but tools do not know that the two documents go together: mirroring or copying the account does not bring the detailed argument with it, and verifiers do not check its pin. An extension (section 4 of the specification) can record the relation for tools, in the account's <verbatim|object.json>, reusing the fields of a member of a selection; the archive lists the extension in the <verbatim|extensions> of its discovery document. For instance (an illustration: no such extension is published yet, and its design is discussed in issue #28):

  <\html-div-class|language-json>
  <\verbatim-code>
    "extensions": {

    \ \ "https://example.org/extensions/companions": {

    \ \ \ \ "companions": [

    \ \ \ \ \ \ {

    \ \ \ \ \ \ \ \ "role": "detailed-argument",

    \ \ \ \ \ \ \ \ "kind": "document",

    \ \ \ \ \ \ \ \ "archive": "tag:example.org,2026:authors",

    \ \ \ \ \ \ \ \ "archiveUrl": "https://authors.example.org/",

    \ \ \ \ \ \ \ \ "id": "kpz-details",

    \ \ \ \ \ \ \ \ "revisions": [

    \ \ \ \ \ \ \ \ \ \ { "documentVersion": 3, "version": "v3", "inventorySha512": "9f2c..." }

    \ \ \ \ \ \ \ \ ]

    \ \ \ \ \ \ }

    \ \ \ \ ]

    \ \ }

    }
  </verbatim-code>
  </html-div-class>

  Tools that know the extension follow it. Verifying the account resolves and checks the companions' pins like the pins of members. Mirroring the account mirrors its companions too, or reports that their licences forbid it. Keeping an accepted copy of the account does the same, and records the relation again in the copy's own <verbatim|object.json>, since an accepted copy does not copy <verbatim|object.json> (section 10.5). Presentations show "the full argument, version 3, as reviewed" beside the account. A selection could also treat the companions, in their pinned versions, as vetted with the account; whether an extension may do so is one of the questions of #28, and in the core the journal pins them itself, in a selection such as <verbatim|issue-7-details>. Tools that do not know the extension still read, copy and verify both documents by the core rules alone.

  The same pattern serves other relations in which one document focuses on another: slides and the paper they present, a survey and the papers it explains, a paper and its formalisation, an article and the data and code of its computations. The core defines none of them, on purpose: it stays small, so that such relations, and in time an infrastructure for scientific knowledge built from them, can be designed on top of it, while the pins keep everything that is built checkable.

  <subsection*|Peer review, from a private submission to a published record><label|peer-review-from-a-private-submission-to-a-published-record>

  The authors prepare a paper in an archive that is not public: an archive of their own kept in a private git repository, or on their own machine. A journal reviews it privately, and in the end publishes the accepted version together with as much of the review as the participants agree to make public (ideally the reports themselves, even if this is not customary today).

  <\itemize>
    <item><strong|A private archive.> The specification describes archives that are served (section 5), but the same files, kept in a private repository, can be deposited, pinned and verified in the same way by whoever has them. Whether such an archive conforms, what <verbatim|archiveUrl> it gives and how its members are resolved are open questions (issue #29). So is its <verbatim|Available> date: the specification asks for the date of deposit (section 8), as for the drafts found later in <hlink|A researcher's own archive|#a-researchers-own-archive>, while a version deposited privately becomes public only later; #29 proposes to leave it out and add it, by a description-only version, when the version is made public.

    <item><strong|Priority without disclosure.> The authors can timestamp each object version with <hlink|OpenTimestamps|https://opentimestamps.org/> (section 13.2). The proof is made on the digest of the inventory, which reveals nothing of the content, and later shows that exactly these files existed at that date. A signature with a key of the authors (section 13.2) shows who made them. The proof holds for these inventories: if the object is later published as a copy, with inventories of its own, the private inventory must be disclosed too for the proof to be checked.

    <item><strong|The submission.> The authors send the journal the object (the whole OCFL object, kept by the journal as a mirror: byte for byte, still the authors' object), or a small collection pinning the objects that go together (the paper, a detailed argument, data). The journal checks what it received against the pins the authors give it. A manuscript under review is usually not licensed for redistribution, while the specification allows mirrors only when the licences allow it (section 10.4): here the mirror is made with the authors' agreement, which the specification does not yet provide for (#29).

    <item><strong|The review as a selection.> The journal keeps, in its own private archive, a selection for each submission. Its members are the documents of the process, each pinned in the version that played its part: the submitted versions, the referees' reports (documents of type <verbatim|PeerReview>, each with <verbatim|Reviews> pointing to the exact object version reviewed), the authors' replies, and the editors' decisions. Each new version of the selection is a step of the process, an act of the editors recorded in its inventory (who, when, and a message saying what was decided), so the history of the selection is the history of the review.

    <item><strong|Objects travel on their own.> Every object is independent of the collections that list it, and can be sent whole: the journal sends a report to the authors as an object, which they keep as a mirror and check against its pin, again by agreement rather than by licence; their reply comes back the same way.

    <item><strong|Anonymous referees.> A fixed version cannot forget what it records: a referee's name in a report's <verbatim|datacite.json> or in its files, or as the depositor in its inventory, could be removed afterwards only by a takedown (section 11.2), which breaks every pin of it. Anonymity must therefore be built in from the start. The journal deposits the reports itself (the inventory names the editorial office as depositor), and witnesses are the journal's, not the referee's. The report's files are cleared of what identifies the referee (PDF metadata, comments in the sources, the <verbatim|toolchain>) before deposit. If the archive is kept in git, commits that are sent or published name the journal, not the referee.

    <item><strong|The referee as a commitment.> In place of the referee's name, the report's creator is a cryptographic <dfn|commitment>: the SHA-512 digest of the referee's identifier (an ORCID iD, which is unambiguous where a name is not) followed by a secret known to the journal and the referee. The commitment is fixed in the report's version, so it cannot be changed afterwards: neither the journal nor anyone else can later attribute the report to someone else. Revealing the identifier and the secret (the referee, to claim the report; the journal, with the referee's agreement or as an institution may require) lets anyone check the attribution by recomputing the digest. A referee who agrees to sign the reports after acceptance is added to their creators, by name, by description-only versions, with the identifier and the secret that open the commitment.

    <item><strong|The secrets.> The secret keeps the referee anonymous until then. Without it, anyone could compute the digests of candidate identifiers until one matches. The journal draws a random secret for each paper, and gives each referee of the paper a secret derived from it: an HMAC of the referee's identifier under the paper's secret. The reports of one referee on one paper, through every round of the review, then carry the same digest, so readers see that they come from the same person. The reports of different referees, or of the same referee on different papers, cannot be linked. Revealing a referee's secret discloses neither the paper's secret nor the other referees. The secrets are kept outside the archive and never deposited: whatever is deposited can never be deleted, and travels with every copy. The papers' secrets are independent of each other, not derived from a single seed of the journal, so a leak of one paper's secret exposes the referees of that paper only.

    <item><strong|The record.> When the paper is accepted, the journal keeps the accepted version, with the reports, the replies and the decisions, in its archive: the complete record of the process, fixed by pins. It publishes only the public part: an accepted copy of the paper (section 10.5) and, with the agreement of those concerned, the reports and replies, listed with the paper in the issue (a selection) or in a public selection of the review. Each report keeps its <verbatim|Reviews> relation to the submitted version it reviewed, and the accepted copy links its reports with <verbatim|IsReviewedBy>. Everything else stays private, still verifiable by those who have it.
  </itemize>

  Open questions for the specification, discussed in issue #29:

  <\itemize>
    <item>how an object kept privately becomes public: the discovery document lists all the objects of an archive, so either an archive may serve only part of them, or publishing is a copy into another archive, with a new identity (and new inventories, so that published reports would pin versions readers cannot resolve);

    <item>what <verbatim|archiveUrl> a private archive gives, and how verifiers resolve its members;

    <item><verbatim|Available> for versions deposited privately;

    <item>mirrors made with the owner's agreement, for objects whose licence does not allow redistribution;

    <item>how a commitment is written as a creator in DataCite (for instance a <verbatim|nameIdentifier> with a scheme of its own), with the exact encoding of what is hashed, so that every tool computes the same digest.
  </itemize>

  <subsection*|A learning record: a thesis, a project, an essay, an experiment><label|a-learning-record-a-thesis-a-project-an-essay-an-experiment>

  A student documents the progression of a piece of work: a thesis, a project, an essay, an experiment. Each revision is kept, with the comments of the supervisors and, at the end, the reports of the examiners. The result is a <dfn|learning record>: an official, verifiable account of how the work was done, not only of what was handed in.

  <\itemize>
    <item><strong|The work.> The work is a document (<verbatim|resourceTypeGeneral> <verbatim|Dissertation> for a thesis, <verbatim|Text> with a <verbatim|resourceType> such as "Essay" or "Project report" otherwise); the data of an experiment and its code are documents of their own (<verbatim|Dataset>, <verbatim|Software>), linked to it by relations. Each revision the student hands in is a new document version, with a <verbatim|changes> note saying what changed (in answer to which comments, with which tools). Its <verbatim|stage> follows a scheme named by the institution (for instance "draft", "submitted for examination", "final"). The inventory records who deposited each version and when, so the history of the object is the log of the work.

    <item><strong|Where it is kept.> The student keeps the work in an archive of their own, which they keep after leaving, or deposits it directly in an archive of the institution; either way the student is its single writer. Until the work is examined the archive is usually private (issue #29). Only what is handed in is deposited: under the proposal of #29, drafts may be changed until they are sent, and sending fixes them.

    <item><strong|Dates.> A timestamp of each object version (section 13.2) shows that this revision existed by that date, which is what a deadline asks; a signature with the student's key shows who deposited it. When the institution keeps a mirror of the work at each submission, the mirror is also its receipt.

    <item><strong|Comments.> The supervisors' comments are documents (<verbatim|Text>, with a <verbatim|resourceType> such as "Supervisor's comments"), each with <verbatim|Reviews> pointing to the exact object version commented on: a short text, an annotated PDF of that version, or both. The student's replies are documents too, or the <verbatim|changes> note of the next revision. A comment therefore always refers to the version it was written about, even after the work has moved on.

    <item><strong|The record as a selection.> The institution keeps, in its archive, a selection for each piece of work. Its members are the documents of the process, each pinned in the version that played its part: the revisions handed in, the comments, the examiners' reports (<verbatim|PeerReview>, with <verbatim|Reviews> pointing to the version examined) and the decision. Each new version of the selection is a step, recorded by the department (who, when, and a message saying what was decided), as for <hlink|peer review|#peer-review-from-a-private-submission-to-a-published-record>. Examiners are usually named; where they are anonymous, they can be recorded as commitments, as referees are there.

    <item><strong|What it shows.> The record does not prove who wrote the work, but it shows how it grew, revision by revision, and what was said about each revision: a body of evidence for the assessment of the work and of the student's part in it, and a record the student can show later, checkable by anyone they give it to.

    <item><strong|What is published.> Usually only the final version, as the thesis in the institution's repository (an accepted copy, section 10.5) or in the student's own archive, made public. The rest of the record, with marks and comments, is personal data (section 16) and stays private, still verifiable by those who have it. When the institution's retention period ends, the record is deleted by a takedown (section 11.2); its tombstones show that it existed, and the student's own copy is not affected.
  </itemize>

  <subsection*|A digest, a reading list, a curated bibliography><label|a-digest-a-reading-list-a-curated-bibliography>

  A researcher publishes a list of recommended papers on a topic, from any OpenSheaf archives.

  <\itemize>
    <item>The list is a <strong|selection>: each member pins the revision she read and recommends. A later version of a paper enters the list only if she adds it, after reading it.

    <item>Nothing is copied, so no permission is needed; the members' cached citations keep the list readable if an archive disappears.

    <item>A selection may contain collections: a digest of digests, or of journal issues, each pinned in the version vetted.
  </itemize>

  <subsection*|A review journal (like Mathematical Reviews or zbMATH Open)><label|a-review-journal-like-mathematical-reviews-or-zbmath-open>

  A review journal publishes short reviews of papers published elsewhere.

  <\itemize>
    <item>Each review is a document of the review journal's archive (<verbatim|resourceTypeGeneral> <verbatim|PeerReview>), written by a reviewer, with <verbatim|relatedIdentifiers> <verbatim|Reviews> pointing to the reviewed paper (its DOI, or the URL of the object version reviewed).

    <item>Reviewed papers kept in OpenSheaf archives form a <strong|selection>: each member pins exactly the revision that was reviewed. When a paper gets a new version, the review stays attached to the reviewed revision, and the selection does not move; a new review of the new version adds a revision to the set, by the editors' act. Papers published only elsewhere (a publisher's site) are linked by the review's <verbatim|Reviews> relation alone.

    <item>Reviews and the selection are kept by the review journal, so the record of what was reviewed, and in which version, is fixed and checkable even if the papers' archives change.
  </itemize>

  <subsection*|Proceedings, special issues, volumes><label|proceedings-special-issues-volumes>

  Proceedings of a conference are a selection of the talks' papers, each vetted in the version presented; a volume is a selection whose members are its issues (collections), each pinned in the version published. A special issue of a journal is a selection of the journal's own documents, or of accepted copies.

  <section*|What happens when ...><label|what-happens-when->

  <block|<tformat|<cwith|1|1|1|-1|font-series|bold>|<cwith|1|-1|1|-1|cell-valign|top>|<cwith|1|-1|1|-1|cell-hyphen|t>|<table|<row|<cell|Event>|<cell|Catalogue (an archive, a storage site)>|<cell|Selection (a journal, a digest)>>|<row|<cell|the authors deposit a new version>|<cell|it is followed (with <verbatim|follow>): the next collection version pins the new head>|<cell|nothing changes; the curator may vet it and add it to the revision set>>|<row|<cell|the authors revise a document that another one focuses on (the detailed argument of a short account)>|<cell|it is followed, like any new version>|<cell|nothing changes: the account, and any selection of the detailed argument, keep pinning the version reviewed; the curator may vet the new one>>|<row|<cell|the authors add a notice or a description>|<cell|it is followed, like any new version>|<cell|not vetted; presentations may show it, saying where it comes from>>|<row|<cell|the authors withdraw the document>|<cell|it is followed: the withdrawn document stays, with its notice>|<cell|the vetted revisions stay, and presentations show the authors' withdrawal notice with the document (section 11.1); the curator decides what else (a notice of its own, a withdrawal of its accepted copy)>>|<row|<cell|the editors correct a vetted version>|<cell|not applicable>|<cell|a new revision in the set, or a new version of the accepted copy: the editors' act, in the selection's history>>|<row|<cell|a document is taken down (by law, or to erase personal data, section 16)>|<cell|the object is deleted and a tombstone stays; verifiers report the member as removed>|<cell|the same for the pinned revisions; an accepted copy is a document of the selection's archive, to which the takedown is applied separately>>|<row|<cell|a document kept privately is made public>|<cell|it can be a member once its archive can be resolved (how, issue #29)>|<cell|the same; published reports keep pointing to the versions they reviewed>>|<row|<cell|a referee signs a report>|<cell|the report's archive adds the referee to its creators by a description-only version, which is followed>|<cell|the revision vetted is unchanged; the editors may vet the signed version as a new revision>>|<row|<cell|the member's archive moves>|<cell|the pin stays valid; readers follow redirects or the mirrors listed in member entries>|<cell|the same>>|<row|<cell|the member's archive disappears>|<cell|members are fetched from mirrors, or any copy matching the pin; Zenodo deposits keep the files but cannot be checked against the pin>|<cell|the accepted copy keeps the vetted revision; references keep their cached citations>>|<row|<cell|a version's licence forbids redistribution>|<cell|the object cannot be mirrored, only referenced>|<cell|the revision cannot be copied, only referenced (unless the authors grant the right)>>>>>

</body>

<\initial>
  <\collection>
    <associate|page-medium|paper>
  </collection>
</initial>
