/* visaul stats */
select
vt.title, v.published_date, v.impressions_count as num_views, v.overall_votes, v.fb_likes, x.fb_comments
from visualizations as v
inner join visualization_translations as vt on vt.visualization_id = v.id
inner join (
select
v.id, sum(vt.fb_count) as fb_comments
from
visualizations as v
inner join visualization_translations as vt on vt.visualization_id = v.id
where v.organization_id = 2
group by v.id, v.published_date, v.impressions_count, v.overall_votes, v.fb_likes
) as x on v.id = x.id
where vt.locale = 'en'
and v.organization_id = 2;

/* category stats */
select
ct.name, count(*) as num_visuals, sum(v.impressions_count) as num_views,
sum(v.impressions_count)/count(*) as views_per_visual,
sum(v.overall_votes) as all_likes, sum(v.overall_votes)/count(*) as likes_per_visual,
sum(v.fb_likes) as fb_likes, sum(v.fb_likes)/count(*) as fb_likes_per_visual
from
category_translations as ct 
inner join visualization_categories as vc on vc.category_id = ct.category_id
inner join visualizations as v on v.id = vc.visualization_id
#inner join visualization_translations as vt on vt.visualization_id = v.id
where ct.locale = 'en'
and v.organization_id = 2
group by ct.name;
 
/*********************************************************/
/* idea stats */
select
i.id, i.created_at, i.impressions_count as num_views, i.overall_votes, i.fb_likes, i.fb_count as fb_comments
from ideas as i
where i.is_deleted = 0 and i.is_public = 1;


/* idea stats per user */
select
u.nickname, if(ou.user_id is null, 0, 1) as belongs_to_org, count(*) as num_ideas, sum(i.impressions_count) as num_views, sum(i.overall_votes), sum(i.fb_likes), sum(i.fb_count) as fb_comments
from ideas as i
inner join users as u on u.id = i.user_id
left join (
select distinct user_id from organization_users 
) as ou on ou.user_id = i.user_id

where i.is_deleted = 0 and i.is_public = 1
group by u.nickname
order by u.nickname;


/* idea stats by org */
select
u.nickname, if(ou.user_id is null, 0, 1) as belongs_to_org, count(*) as num_ideas, sum(i.impressions_count) as num_views, sum(i.overall_votes), sum(i.fb_likes), sum(i.fb_count) as fb_comments
from ideas as i
inner join users as u on u.id = i.user_id
left join (
select distinct user_id from organization_users 
) as ou on ou.user_id = i.user_id

where i.is_deleted = 0 and i.is_public = 1
group by u.nickname
order by u.nickname;


/* idea status stats */
select
i.current_status_id, if(ist.name is null, 'Not Chosen', ist.name) as `status`, count(*)
from ideas as i
left join idea_status_translations as ist on ist.idea_status_id = i.current_status_id and ist.locale = 'en'
where i.is_deleted = 0 and i.is_public = 1
group by i.current_status_id, ist.name
order by i.current_status_id;


/* category stats */
select
ct.name, count(*) as num_ideas, sum(i.impressions_count) as num_views,
sum(i.impressions_count)/count(*) as views_per_idea,
sum(i.overall_votes) as all_likes, sum(i.overall_votes)/count(*) as likes_per_idea,
sum(i.fb_likes) as fb_likes, sum(i.fb_likes)/count(*) as fb_likes_per_idea
from
category_translations as ct 
inner join idea_categories as ic on ic.category_id = ct.category_id
inner join ideas as i on i.id = ic.idea_id
where ct.locale = 'en'
and i.is_deleted = 0 and i.is_public = 1
group by ct.name;

