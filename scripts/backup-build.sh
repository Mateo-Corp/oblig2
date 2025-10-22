#!/bin/bash
set -e

echo "📦 Building Terraform Artifact..."
echo ""

# Generate version from git or timestamp
if git rev-parse --git-dir > /dev/null 2>&1; then
  VERSION=$(git rev-parse --short HEAD)
else
  VERSION=$(date +%Y%m%d-%H%M%S)
fi

echo "Version: $VERSION"
echo ""

# Validate Terraform
echo "1️⃣ Validating Terraform..."
cd terraform
terraform fmt -recursive || (echo "⚠️  Run 'terraform fmt -recursive' to fix formatting" && exit 1)
terraform init -backend=false
terraform validate
cd ..

echo "✅ Validation complete!"
echo ""

# Create artifact
echo "2️⃣ Creating artifact..."
ARTIFACT_NAME="terraform-${VERSION}.tar.gz"

tar -czf $ARTIFACT_NAME \
  terraform/ \
  environments/ \
  backend-configs/

echo "✅ Artifact created: $ARTIFACT_NAME"
echo ""

azcopy copy ./$ARTIFACT_NAME 'https://sttfstatems.blob.core.windows.net/tfstate?se=2025-10-28&sp=rwl&sv=2022-11-02&sr=c&skoid=539ff64e-03c1-45ae-b89a-48f60c619663&sktid=888fa0b1-f240-41c2-b84b-dfd815958958&skt=2025-10-22T12%3A41%3A47Z&ske=2025-10-28T00%3A00%3A00Z&sks=b&skv=2022-11-02&sig=gTCtrxn1YY%2BLw%2BiAYKwc02Zd2KKjCOPB9CNzZ5%2BHpFI%3D' --recursive

# Show artifact info
echo "📊 Artifact Information:"
ls -lh $ARTIFACT_NAME
echo ""
echo "🎯 Next steps:"
echo "  - Deploy to dev:  ./scripts/deploy.sh dev $ARTIFACT_NAME"
echo "  - Deploy to test: ./scripts/deploy.sh test $ARTIFACT_NAME"
echo "  - Deploy to prod: ./scripts/deploy.sh prod $ARTIFACT_NAME"