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

## Resource - Configure Git Credentialss
1. SSH    
Create an SSH GitHub key. Go to github.com → Settings → SSH and GPG keys → New SSH Key. Now save your private key to your computer.
Then, if the private key is saved as id_rsa in the ~/.ssh/ directory, we add it for authentication as such:
```
ssh-add -K ~/.ssh/id_rsa
```
2. Caching (Default Options in Docker Image)    
We can use git-credential-store to cache our username and password for a time period. Simply enter the following in your CLI (terminal or command prompt):
```
git config --global credential.helper cache
```
You can also set the timeout period (in seconds) as such:
```
git config --global credential.helper 'cache --timeout=3600'
```
3. Store   
Git-credential-store may also be used, but it saves passwords in a plain text file on your disk as such:
```
git config credential.helper store
```

## Resource - Store Git Username & Password
1. Option 1 (By default): username & password is stored in Cache (see Dockerfile). So, everytime, you rerun docker, username & password need to be retyped.   
2. Option 2 (no secure) (See Resource - Configure Git Credentialss)   
```
git config --global credential.helper store
```
3. Option 2 (use SSH)  (See Resource - Configure Git Credentialss)   

## Resource - Store SSH KeyPhrase 
1. In Docker Container, run below comand, see https://gist.github.com/nepsilon/45fae11f8d173e3370c3:     
```
eval $(ssh-agent) && ssh-add ~/.ssh/id_rsa 
```
or 
```
ssh-agent bash
ssh-add ~/.ssh/id_rsa 
exit
```


## ToDo
1. ~~Github credentials & Gitlab passphrase~~       
2. Read mirror configuration from SQLite or configuration file.  
3. ~~Solve Gitlab Repository Push Rule settings.~~    
4. Make docker run simple   
5. Cron Job  
6. More examples for add/update/ls/...   
7. ~~Allow multi-level groups (currently, only work for one level group name)~~   
8. ~~Group name upcase, lowercase issue.~~   
9. Move pushrules_prevent_secrets to per project setting.     
10. Implement import  (add -> update;  or import -> add -> update;)

## Long Term
1. Implement a webui so that we can work on UI instead of command.   
2. Implement agent logic to avoid security risk.  

## Test
1. Add works    
2. Update ?   
3. List ?   
4. Delete ?   


## Resources
1. https://python-gitlab.readthedocs.io/en/stable/gl_objects/groups.html#reference  
2. https://github.com/nmklotas/GitLabApiClient   

## Open Source reference
Thank Klowner and Samrocketman for their projects.
1. docker-gitlab-mirrors is from https://github.com/Klowner/docker-gitlab-mirrors    
2. docker-mirrors is based from https://github.com/samrocketman/gitlab-mirrors   

