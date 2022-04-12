#!/usr/bin/env python

# We favor PEP8 formatting, which is actually a pretty lengthy document and has
# some awesome legacy rules in it that fall somewhere between cutting the ends
# off of grandma's pot roast and outright cargo culting. BUT style is style, and
# Python is all about a single agreed-upon style. Remember the big push in 2018
# or so to standardize on a single rubocop.yml file for all developers
# everywhere? Yeah, this is that, only ORWTDI is baked into the Python culture,
# so it actually worked. Works. Worksssss.
pants = False

if pants:
    always_favor_four_spaces_per_indent
    use_tabs_only_in_legacy_documents_that_already_have_tabs_and_cant_or_shouldnt_be_cleaned_up
    never_ever_mix_tabs_and_spaces_because_that_literally_a_syntax_error_now

def wrap_code_at_seventy_nine_characters(with_multiple_strategies_for_methods,
                                     that_have_their_arguments_wrapped):
    """Docstrings and other things that wrap more fluidly, however, must
wrap at 72 characters."""
    return 42
