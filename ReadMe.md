## Build Docker Image
```
docker build -f Dockerfile -t docker-gitlab-tools-mirrors . 
```

## Errors
1. Copy both private and public rsa, set permission 400 or 600
```
chmod 600 /Users/yding/config/id_rsa
```    
2. passpharse: https://unix.stackexchange.com/questions/12195/how-to-avoid-being-asked-passphrase-each-time-i-push-to-bitbucket    
3. Remoted rejected: pre-receive hook declined, https://stackoverflow.com/questions/39360527/git-push-with-wrong-user-and-pre-receive-hook-declined    
   Solution:
   -- Gitlab -> Settings -> Repository -> Push Rules, disable all commit restriction  (Prevent pushing secret files)


## Examples
```
docker run --rm -it \
  -v /Users/yding/config:/config \
  -v /Users/yding/mirrors:/data/mirrors \
  -e GITLAB_MIRROR_GITLAB_USER=yding \
  -e GITLAB_MIRROR_GITLAB_NAMESPACE=Mirror \
  -e GITLAB_MIRROR_GITLAB_URL=https://gitlab.example.com \
  docker-gitlab-tools-mirrors \
  add --git --project-name test --mirror https://github.com/dingyuliang/test
```
