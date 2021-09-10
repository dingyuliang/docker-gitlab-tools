## Open Source reference
1. docker-gitlab-mirrors is from https://github.com/Klowner/docker-gitlab-mirrors    
2. docker-mirrors is based from https://github.com/samrocketman/gitlab-mirrors   

## Build Docker Image
```
cd src/mirrors    
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


## Examples (Github to Gitlab)
1. Run Docker Container
```
   docker run --rm -it \
  -v /Users/yding/github2gitlab/private_token:/home/gitmirror/private_token \
  -v /Users/yding/github2gitlab/config.sh:/home/gitmirror/gitlab-mirrors/config.sh:ro \
  -v /Users/yding/github2gitlab/ssh-key:/home/gitmirror/.ssh \
  -v /Users/yding/github2gitlab/repositories:/home/gitmirror/repositories \
  docker-gitlab-tools-mirrors  \
  /bin/bash 
```
2. In docker container, add a new repository mirror.    
```
add_mirror.sh --git --group-path rootgroup/testgroup --project-name test_mirrors --mirror https://github.com/dingyuliang/test
```
3. In docker container, update an existing repository sync  
Required project already cloned in disk      
```
update_mirror.sh test_mirrors rootgroup/testgroup 
``` 


## ToDo
1. Github credentials & Gitlab passphrase       
2. Read mirror configuration from SQLite or configuration file.  
3. Solve Gitlab Repository Push Rule settings.    
4. Make docker run simple   
5. Cron Job  
6. More examples for add/update/ls/...   
7. ~~Allow multi-level groups (currently, only work for one level group name)~~   
8. ~~Group name upcase, lowercase issue.~~   
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
  

