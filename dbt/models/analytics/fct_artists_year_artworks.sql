{{ config(
    materialized="table",
    alias = "metropolitan_artists_biography") }}


with biography as

    (select ay.artistdisplayname, 
    ay.yearFromLife as artist_year,
    ay.artistAliveCurrentYear,
    aw.artworkExecutionYear as artwork_year, 
    aw.title as artwork_title
    from {{ ref("artists_years") }} ay
    left join
    {{ ref("artwork_years") }} aw on ay.yearFromLife = aw.artworkExecutionYear and ay.artistdisplayname = aw.artistdisplayname
    order by artistdisplayname, artist_year),

years_artworks_string as (

select distinct
  artistdisplayname,
  artist_year,
  STRING_AGG(artwork_title, '; ') as artwork_titles
from biography
group by artistdisplayname, artist_year
)


SELECT 
    B.artistdisplayname,
    B.artist_year,
    B.artwork_year,
    B.artwork_title,
    B.artistAliveCurrentYear,
    ArtStr.artwork_titles
FROM  
    biography B
 LEFT JOIN
    years_artworks_string ArtStr
ON B.artistdisplayname = ArtStr.artistdisplayname AND B.artist_year = ArtStr.artist_year
ORDER BY B.artistdisplayname, B.artist_year
