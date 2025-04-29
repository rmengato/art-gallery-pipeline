{{ config(materialized="view") }}

select

    md5id,
    artistdisplayname,
    artistprefix,
    artistdisplaybio,
    artistsuffix,
    artistalphasort,
    artistnationality,
    artistbegindate,
    artistenddate,
    artistgender,
    artistwikidata_url,
    artistulan_url,
    batchtimestamp
from {{ source("qr_art_gallery_raw", "staging_metropolitan") }}
