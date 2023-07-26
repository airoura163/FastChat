#!/bin/bash
  
tmux new-session -d -s start_webui

## Create the windows on which each node or .launch file is going to run
tmux send-keys -t start_webui 'tmux new-window -n controller ' ENTER
tmux send-keys -t start_webui 'tmux new-window -n worker ' ENTER
tmux send-keys -t start_webui 'tmux new-window -n gradio ' ENTER

## Send the command to each window from window 0
# NAME1
tmux send-keys -t start_webui "tmux send-keys -t controller 'python3 -m fastchat.serve.controller' ENTER" ENTER

# NAME2
if [ -d "./checkpoints" ]; then
        tmux send-keys -t start_webui "tmux send-keys -t worker 'python3 -m fastchat.serve.model_worker --model-path /workspace/fschat_plus/FastChat/checkpoints' ENTER" ENTER
else
        tmux send-keys -t start_webui "tmux send-keys -t worker 'python3 -m fastchat.serve.model_worker --model-path huggyllama/llama-7b' ENTER" ENTER
fi

sleep 1m

# NAME3
tmux send-keys -t start_webui "tmux send-keys -t gradio 'python3 -m fastchat.serve.gradio_web_server --share' ENTER" ENTER

## Start a new line on window 0
tmux send-keys -t start_webui ENTER

## Attach to session
tmux attach -t start_webui