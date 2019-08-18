# FYI: https://ipython.readthedocs.io/en/stable/config/details.html#custom-prompts
from IPython.terminal.prompts import Prompts, Token

class DocTestPrompt(Prompts):
    def in_prompt_tokens(self, cli=None):
        return [(Token.Prompt, '>>> ')]

    def out_prompt_tokens(self):
        return [(Token.Prompt, '')]

c.TerminalInteractiveShell.prompts_class = DocTestPrompt
