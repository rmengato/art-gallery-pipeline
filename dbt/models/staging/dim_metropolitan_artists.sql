{{ config(materialized="view") }}

select
    md5id,
    any_value(artistdisplayname) as artistdisplayname,
    any_value(artistprefix) as artistprefix,
    any_value(artistdisplaybio) as artistdisplaybio,
    any_value(artistsuffix) as artistsuffix,
    any_value(artistalphasort) as artistalphasort,
    any_value(artistnationality) as artistnationality,
    any_value(artistbegindate) as artistbegindate,
    any_value(artistenddate) as artistenddate,
    any_value(artistgender) as artistgender,
    any_value(artistwikidata_url) as artistwikidata_url,
    any_value(artistulan_url) as artistulan_url,
    min(batchtimestamp) as first_loaded_at
from {{ ref("staging_metropolitan_artists_view") }}
group by md5id
