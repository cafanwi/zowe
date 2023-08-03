
***K8 Copy***

```
 k cp copy-c5ccbc4dd-5fdgh:/copy/ .
 k cp copy-c5ccbc4dd-5fdgh:/copy/ ~/Downloads/test-folder/
 k cp copy-c5ccbc4dd-5fdgh:/copy/copy-file.yaml ../../Downloads/test-folder    # this created a folder
 k cp cafanwi-chart copy-c5ccbc4dd-5fdgh:/copy/           # copy to the container
```

***Create K alias for ever***

```
echo "alias k='kubectl'" >> ~/.bashrc && source ~/.bashrc       
```
