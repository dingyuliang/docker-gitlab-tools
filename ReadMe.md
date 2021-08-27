## Open Source reference
1. docker-gitlab-mirrors is from https://github.com/Klowner/docker-gitlab-mirrors    
2. docker-mirrors is based from https://github.com/samrocketman/gitlab-mirrors   

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
3. rejected: pre-receive hook declined, here is the error message.
```
pre-receive hook declined
```
Possible Solution: https://stackoverflow.com/questions/39360527/git-push-with-wrong-user-and-pre-receive-hook-declined    
Gitlab Solution (you may have some rules block pushing):
   --> Gitlab -> Settings -> Repository -> Push Rules, Disable all commit restriction  (Prevent pushing secret files)


## Examples
1. Add a new repository mirror.    
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
2. Update an existing repository sync  
Required project already cloned in disk      
```
docker run --rm -it \
  -v /Users/yding/config:/config \
  -v /Users/yding/mirrors:/data/mirrors \
  -e GITLAB_MIRROR_GITLAB_USER=yding \
  -e GITLAB_MIRROR_GITLAB_NAMESPACE=Mirror \
  -e GITLAB_MIRROR_GITLAB_URL=https://gitlab.example.com \
  docker-gitlab-tools-mirrors \
  update test
``` 


## ToDo
1. Github credentials & Gitlab passphrase  
2. Mirror Path seems doesn't work. No code is downloaded into local mirror folder.     
2. Read mirror configuration from SQLite or configuration file.  
3. Solve Gitlab Repository Push Rule settings.    
4. Make docker run simple   
5. Cron Job  
6. More examples for add/update/ls/...   
7. Allow multi-level groups (currently, only work for one level group name)  
8. Group name upcase, lowercase issue.   
9. Move pushrules_prevent_secrets to per project setting.     
10. Implement import  (add -> update;  or import -> add -> update;)

## Test
1. Add works    
2. Update ?   
3. List ?   
4. Delete ?   


## Resources
1. https://python-gitlab.readthedocs.io/en/stable/gl_objects/groups.html#reference  
2. https://github.com/nmklotas/GitLabApiClient   
  

