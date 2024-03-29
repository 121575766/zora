# 更新组件
sudo apt-get update && sudo apt-get upgrade -y
sudo apt install curl build-essential git screen jq pkg-config libssl-dev libclang-dev ca-certificates nano gnupg lsb-release -y

# 安装Docker
# Check if Docker is installed
if command -v docker &> /dev/null; then
    echo "Docker is already installed. Skipping installation."
else
    # Install Docker
    sudo apt-get install ca-certificates curl gnupg -y
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    echo \
      "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
      $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
      sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    sudo apt-get update -y
    sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin -y
    systemctl start docker
    systemctl enable docker
fi

# Check if Docker Compose is installed
if command -v docker-compose &> /dev/null; then
    echo "Docker Compose is already installed. Skipping installation."
else
    # Install Docker Compose
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
fi

# 下载资源
git clone https://github.com/conduitxyz/node.git
cd node
./download-config.py zora-mainnet-0
export CONDUIT_NETWORK=zora-mainnet-0
cp .env.example .env

# 修改env
# Note: This will open the nano editor, the script will pause until you exit nano
nano .env

# Docker组建
docker-compose up --build