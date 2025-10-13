# Powerlevel10k Instant Prompt

When you install **Powerlevel10k**, the setup wizard will ask whether you want to enable **Instant Prompt**.  
This feature is optional, but very useful for many users.

---

## What Is Instant Prompt?

Normally, when you launch a new shell, Zsh has to:
- Load `.zshrc`
- Initialize Oh My Zsh (if used)
- Load plugins and themes

This can cause a small but noticeable delay before you see a usable prompt.

**Instant Prompt** moves part of the initialization earlier, so you get an immediate, usable prompt **before the rest of Zsh finishes loading**. Once loading is complete, the prompt updates seamlessly.

---

## Pros

- **Faster perceived startup** — your shell feels instant.  
- Especially helpful if you have a large `.zshrc` or lots of plugins.  
- Widely used and well supported in Powerlevel10k.  

---

## Cons

- Rarely, some plugins that print messages during startup may cause glitches.  
- Creates a small cache file under `~/.cache/p10k-instant-prompt-*`.  
- If your config is already minimal and startup is fast, it won’t add much benefit.  

---

## Should You Use It?

- **Yes** if you want a snappier, more responsive terminal startup.  
- **No harm** in enabling it; if you run into issues, it’s easy to turn off.  

---

## How to Enable/Disable Later

If you change your mind, you can toggle Instant Prompt by editing your `~/.zshrc`.

Look for this block near the top:
```zsh
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
if [[ -r "~/.cache/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "~/.cache/p10k-instant-prompt-${(%):-%n}.zsh"
fi