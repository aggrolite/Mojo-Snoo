package Mojo::Snoo::Thing;
use Mojo::Base 'Mojo::Snoo::Base';
use Mojo::Collection;

has [
    qw(
	approved_by
	archived
	author
	author_flair_css_class
	author_flair_text
	banned_by
	clicked
	created
	created_utc
	distinguished
	domain
	downs
	edited
	gilded
	hidden
	id
	is_self
	likes
	link_flair_css_class
	link_flair_text
	media
	media_embed
	mod_reports
	name
	num_comments
	num_reports
	over_18
	permalink
	report_reasons
	saved
	score
	secure_media
	secure_media_embed
	selftext
	selftext_html
	stickied
	subreddit
	subreddit_id
	thumbnail
	title
	ups
	url
	user_reports
	visited
      )
];

has comments => \&_build_comments;

sub _build_comments {};

sub save {};

1;
