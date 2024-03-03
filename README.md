# ZSH-GPT

Simple ZSH plugin to allow querying ChatGPT from the command line. Forked from Muhsin Fatih Yorulmaz (https://github.com/antonjs/zsh-gpt).

```
zsh-gpt ❯ gpt - c Write a python hello world to the home directory
echo 'print("Hello, World!")' > ~/hello_world.py

zsh-gpt ❯ gpt hi
How can I assist you today?

zsh-gpt ❯ gpt
Type 'exit' to quit and 'clear' to clear the history
> How many feet are in one meter?
3.28084 feet
> How do I sync files from one folder to another?
rsync -avz /path/to/source/ /path/to/destination/
> Compose an email to a colleague. It communicates that we are going to delay the launch date due to external dependencies.
Subject: Update on Project Launch Date

Dear [Colleague's Name],

I hope this email finds you well. I wanted to update you on our project's timeline. Due to some external dependencies that are beyond our control, we've had to make the decision to delay the launch date. We are currently working closely with our partners to resolve these issues and will keep you informed on our progress and the new timeline.

Thank you for your understanding and cooperation.

Best regards,
[Your Name]
```

## Install

### Set OPENAI_API_KEY
Set OPENAI_API_KEY in `.zshrc` or otherwise:
`OPENAI_API_KEY = [key]`

### Plugin Managers
Add TerryvanWalen/zsh-gpt using whatever format the plugin manager expects:

#### For Oh My Zsh
1. Clone this repository into `$ZSH_CUSTOM/plugins` (by default `~/.oh-my-zsh/custom/plugins`)
```
git clone https://github.com/TerryvanWalen/zsh-gpt ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-gpt
```
2. Add the plugin to the list of plugins for Oh My Zsh to load (inside `~/.zshrc`):
```
plugins=( 
    # other plugins seperated by spaces or newlines (not commas)
    zsh-gpt
)
```

### Manual
1. Clone this repository: `git clone TerryvanWalen/zsh-gpt ~/.zsh/zsh-gpt`
2. Source the plugin in your `.zshrc`: `source ~/.zsh/zsh-gpt/zsh-gpt.plugin.zsh`
3. Set OPENAI_API_KEY in `.zshrc` or otherwise:
  `OPENAI_API_KEY = [key]`
4. Start a new terminal session

## Usage
+ For shell or code related questions. Type `gpt -c [query]` where `[query]` is your question.
+ For other questions. Type `gpt [query]` where `[query]` is your question.
+ For a chat like experience. Type `gpt`.


# TODOS
- [ ] Provide better options
  - [ ] Provide/store system message
  - [ ] Provide an option for gpt to give concise/explantory answers
  - [ ] Limit the conversation history provided to gpt to the last `n` questions/answers
  - [ ] Provide the option to switch between models
  - [ ] Provide the OPENAI_API_KEY as an argument
- [ ] Colorize output (especially in chat mode)
- [ ] Save the OPENAI_API_KEY more securely
- [ ] Readme
  - [ ] How to install for other plugin managers