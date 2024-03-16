#!/usr/bin/env zsh
# Based on https://github.com/antonjs/zsh-gpt

_assert_prerequisites() {
    if [[ ! $+commands[curl] ]]; then echo "Curl must be installed."; return 1; fi
    if [[ ! $+commands[jq] ]]; then echo "Jq must be installed."; return 1; fi
    if [[ -z "$OPENAI_API_KEY" ]]; then echo "Must set OPENAI_API_KEY to your API key"; return 1; fi
}

_create_prompt() {
    echo '{"role": "user", "content": "'"$*"'"}'
}

_curl_gpt() {
    local system="$1"
    local messages="$2"
    curl https://api.openai.com/v1/chat/completions -s \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $OPENAI_API_KEY" \
        -d '{
            "model": "gpt-4-turbo-preview",
            "messages": [{"role": "system", "content": "'"$system"'"}, '"$messages"']
    }' | jq '.choices[0].message // .error'
}

_prompt_gpt() {
    local system="$1"
    shift
    local prompt="$(_create_prompt $*)"
    local reply="$(_curl_gpt "$system" "$prompt")"
    printf '%s\n' "$reply" | jq -r ".content // ."
}

_chat_gpt() {
    clear
    local chat_help="Type 'exit' to quit and 'clear' to clear the history"
    echo "$chat_help"
    
    conversation_history=()
    local system="you''re an in-line zsh assistant running on macos. Your task is to answer the questions without any commentation at all, providing only the result asked. You can assume that the user understands that they need to fill in placeholders like <NAME>. You only provide concise answers. Keep the responses to one-liners if possible and never use more than 100 words. Do not decorate the answer with tickmarks"
    while true; do
        unset user_input
        vared -p "> " -c user_input

        if [[ "$user_input" == "exit" ]]; then
            echo "Exiting chat..."
            break
        fi
        if [[ "$user_input" == "clear" ]]; then
            clear
            echo "$chat_help"
            conversation_history=()
            continue;
        fi
        local prompt="$(_create_prompt $user_input)"
        # If not valid string according to jq. Then show message and continue to next loop
        echo "$prompt" | jq > /dev/null || continue
        conversation_history+="$prompt"

        local messages=${(j|, |)conversation_history}
        reply="$(_curl_gpt "$system" "$messages")"
        
        # Only add reply if a valid response is given
        echo "$reply" | jq 'has(".content")' > /dev/null && conversation_history+="$reply"
        printf '%s\n' "$reply" | jq -r ".content // ."
    done
}

prompt_text="you''re an in-line zsh assistant running on macos. Your task is to answer the questions without any commentation at all, providing only the result asked. You can assume that the user understands that they need to fill in placeholders like <NAME>. You only provide concise answers. Keep the responses to one-liners if possible and never use more than 100 words. Do not decorate the answer with tickmarks"
prompt_code="you''re an in-line zsh assistant running on macos. Your task is to answer the questions without any commentation at all, providing only the code to run on terminal. You can assume that the user understands that they need to fill in placeholders like <PORT>. You''re not allowed to explain anything and you''re not a chatbot. You only provide shell commands or code. Keep the responses to one-liner answers as much as possible. Do not decorate the answer with tickmarks"

gpt() {
    _assert_prerequisites

    if [[ "$1" == "" ]]; then
        _chat_gpt
    elif [[ "$1" == "-c" ]]; then
        shift
        _prompt_gpt "$prompt_code" "$*"
    else
        shift
        _prompt_gpt "$prompt_text" "$*"
    fi
}