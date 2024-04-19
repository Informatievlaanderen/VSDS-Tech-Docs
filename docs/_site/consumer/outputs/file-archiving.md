# Archive File Out

<b>LDIO Component Name:</b> <i>`Ldio:LdioArchiveFileOut`</i> see [reference guide]() <br>
<b>Apache Nifi Component Name:</b> <i>`ArchiveFileOut` </i> see [Apache Nifi reference guide]()

The Archive File Out is used to write models to files based on a timestamp path property on the model.
Every file is written to NQuads with the extracted timestamp as name: 2023-11-21-05-05-00-000000000.nq
When two files have the same name, a sequence nr is added, for example: 2023-11-21-05-05-00-000000000-2.nq

The files are ordered in directories based on the date. For every day, there is one directory.
For example: 2023-11-21-05-05-00-000000000.nq will be located at archive-root-dir/2023/11/21.
