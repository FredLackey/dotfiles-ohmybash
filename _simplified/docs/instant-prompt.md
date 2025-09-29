# Powerlevel10k Instant Prompt

When you install **Powerlevel10k**, the setup wizard may ask whether to enable **Instant Prompt**. This feature is optional.

---

## What It Does
Normally, Zsh loads `.zshrc`, Oh My Zsh, and plugins before showing a prompt. **Instant Prompt** shows a usable prompt immediately while the rest finishes loading in the background.

---

## Pros
- Faster perceived startup
- Great for large `.zshrc` or many plugins
- Safe and widely used

## Cons
- Rare visual glitches if a plugin prints during startup
- Writes small cache files under `~/.cache/p10k-instant-prompt-*`
- Little benefit if your config is already very fast

---

## Toggle It Later
Look near the top of `~/.zshrc` for a block like this:
```zsh
# Enable Powerlevel10k instant prompt. Keep near the top of ~/.zshrc.
if [[ -r "~/.cache/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "~/.cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi
```
- Comment it out to **disable**
- Uncomment to **enable**

---

## Recommendation
If you want a snappy terminal, enable it. It’s easy to turn off if something misbehaves.
