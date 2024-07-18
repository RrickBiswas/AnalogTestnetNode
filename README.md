# AnalogTestnetNode
If you're stuck on block 1,299,707, please follow the below steps!

Use this command, Replce YOURNODENAME with your actual node name

wget https://raw.githubusercontent.com/RrickBiswas/AnalogTestnetNode/main/update_analog_testnet_node.sh && chmod +x update_analog_testnet_node.sh && ./update_analog_testnet_node.sh YOURNODENAME


If you notice that the log repeatedly shows the same block number (#1304465) without progressing further.

Restart your Docker container:

sudo docker restart YOURNODENAME
