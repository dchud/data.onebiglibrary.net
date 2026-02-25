#!/usr/bin/env python

AUTHOR = 'dchud'
SITENAME = 'data.onebiglibrary.net'
SITEURL = ''

PATH = 'content'

TIMEZONE = 'America/New_York'

DEFAULT_LANG = 'en'

# Feed generation is usually not desired when developing
FEED_DOMAIN = SITEURL
FEED_ALL_ATOM = 'feeds/all.atom.xml'
FEED_ALL_RSS = None
CATEGORY_FEED_ATOM = None
CATEGORY_FEED_RSS = None
TAG_FEED_ATOM = None
TAG_FEED_RSS = None
TRANSLATION_FEED_ATOM = None
TRANSLATION_FEED_RSS = None

ARTICLE_PATHS = ['posts']
STATIC_PATHS = ['data', 'posts']

DEFAULT_PAGINATION = 0

RELATIVE_URLS = True

THEME = 'theme'

PLUGINS = ['sitemap']

ARTICLE_URL = '{date:%Y}/{date:%m}/{date:%d}/{slug}/'
ARTICLE_SAVE_AS = '{date:%Y}/{date:%m}/{date:%d}/{slug}/index.html'
PAGE_URL = '{slug}/'
PAGE_SAVE_AS = '{slug}.html'
YEAR_ARCHIVE_SAVE_AS = '{date:%Y}/index.html'
MONTH_ARCHIVE_SAVE_AS = '{date:%Y}/{date:%m}/index.html'

ARCHIVES_SAVE_AS = ''
AUTHOR_SAVE_AS = ''
AUTHORS_SAVE_AS = ''
CATEGORY_SAVE_AS = ''
CATEGORIES_SAVE_AS = ''
#TAG_SAVE_AS = ''
TAGS_SAVE_AS = ''

DISPLAY_PAGES_ON_MENU = False
DISPLAY_CATEGORIES_ON_MENU = False

DEFAULT_CATEGORY = 'misc'

FILENAME_METADATA = r'(?P<date>\d{4}\d{2}\d{2})-(?P<slug>.*)'
PATH_METADATA = r'posts/(?P<date>\d{8})-(?P<slug>[^/]+)/.*'
DEFAULT_DATE_FORMAT = '%Y-%m-%d'


SITEMAP = {
    'format': 'xml',
    'priorities': {
        'articles': 0.5,
        'indexes': 0.5,
        'pages': 0.5,
    },
    'changefreqs': {
        'articles': 'monthly',
        'indexes': 'daily',
        'pages': 'monthly'
    }
}

try:
    from pelicanconflocal import *
except ImportError:
    print('No local settings found.')
