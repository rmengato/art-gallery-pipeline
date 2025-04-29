{{ config(materialized="view") }}

with
    artists as (
        select distinct
            artistdisplayname,
            department,
            artistNationality,
            safe_cast(artistbegindate as int64) as artistStartYear,
        case
            when
                safe_cast(artistenddate as int64) > extract(year from current_date())
            then
                extract(year from current_date())
            else
               safe_cast(artistenddate as int64)
            end as ArtistEndYear,
        case
            when 
                safe_cast(artistenddate as int64) > extract(year from current_date())
            then 
                true
            else 
                false
        end as artistAliveCurrentYear
        from {{ source("qr_art_gallery_raw", "staging_metropolitan") }}
        where
            safe_cast(artistbegindate as int64) is not null
            and safe_cast(artistenddate as int64) is not null
            and classification like '%ainting%'
            and safe_cast(artistbegindate as int64) >= 0
    )

select distinct artistdisplayname, artistNationality, artistStartYear, ArtistEndYear, yearFromLife, artistAliveCurrentYear
from artists, unnest(generate_array(artistStartYear, ArtistEndYear)) as yearFromLife
