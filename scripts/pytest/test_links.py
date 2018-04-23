import re
import os
import requests

# Regular expression for identifying a web link in a markdown file
link_regex = re.compile(r"""
    \[.+\]     # Identifies the rendered text that will eventually be shown in hyperlink
    \(         # Opening braces that precedes the hyperlink
    (?!.*md.*) # Negative lookahead. Asserts the link is not another markdown file
    (.+?)      # Identifies the URL
    \)         # Closing braces that proceeds the hyperlink
    """, re.VERBOSE)

# Certain links without user-agent will return 403 response even though the link exists with requests.get
headers = {'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/60.0.3112.113 Safari/537.36'}

def test_working_links():
    """
    Make sure all the links in this repo still works
    """
    for basedir, _, files in os.walk('./../../contents/'):
        for f in files:
            filepath = os.path.join(basedir, f)
            with open(filepath) as current_file:
                links = link_regex.findall(current_file.read())
            for link in links:
		try:
	            assert requests.get(link, headers=headers).status_code == 200, \
		           ''.join([link, ' in ', filepath, ' is broken'])
		except requests.ConnectionError:
		    raise AssertionError(''.join([link, ' in ', filepath, ' is broken']))
