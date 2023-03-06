from jaseci.actions.live_actions import jaseci_action
import re
@jaseci_action(act_group=["regex"], allow_remote=True)
def sanitize_html_tags(data: str):
    tag_regex = re.compile(r'<[^>]+>')
    return tag_regex.sub('', data)
