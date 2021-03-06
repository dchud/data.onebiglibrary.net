#!/usr/bin/env python
# -*- coding: utf-8 -*- #
from __future__ import unicode_literals

AUTHOR = u'dchud'
SITENAME = u'data.onebiglibrary.net'
#SITEURL = 'http://localhost:8000'
SITEURL = 'http://data.onebiglibrary.net'

PATH = 'content'

TIMEZONE = 'America/New_York'

DEFAULT_LANG = u'en'

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

STATIC_PATHS = ['data', 'images']

DEFAULT_PAGINATION = 0

# Uncomment following line if you want document-relative URLs when developing
RELATIVE_URLS = False

THEME = 'theme' # 'simple' # 'blueidea' # 'notmyidea'

PLUGIN_PATHS = [
    'plugins', 
    '/Users/dchud/projects/pelican-plugins',
    ]

PLUGINS = [
    'liquid_tags.liquid_tags',
    'liquid_tags.notebook',
    'sitemap',
    ]

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

DEFAULT_CATEGORY = ''

#TWITTER_USERNAME = 'dchud'

FILENAME_METADATA = '(?P<date>\d{4}\d{2}\d{2})-(?P<slug>.*)'
DEFAULT_DATE_FORMAT = '%Y-%m-%d'

EXTRA_HEADER = open('_nb_header.html').read().decode('utf-8')
NOTEBOOK_DIR = '/Users/dchud/projects/data.onebiglibrary.net/content/notebooks'

GOOGLE_ANALYTICS = ''

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
except:
    print 'No local settings found.'
