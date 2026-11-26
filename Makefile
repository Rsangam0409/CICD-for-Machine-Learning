install:
	python -m pip install --upgrade pip
	python -m pip install -r requirements.txt

format:
	python -m black *.py

train:
	python train.py

eval:
	echo "## Model Metrics" > report.md
	cat ./Results/metrics.txt >> report.md
	echo "" >> report.md

	echo "## Confusion Matrix Plot" >> report.md
	echo "The confusion matrix plot is attached as the 'results' artifact of [this workflow run]($${GITHUB_SERVER_URL}/$${GITHUB_REPOSITORY}/actions/runs/$${GITHUB_RUN_ID})." >> report.md
	cat report.md

	cml comment create --publish=false report.md

update-branch:
	git config --global user.name $(USER_NAME)
	git config --global user.email $(USER_EMAIL)
	git commit -am "Update with new results"
	git push --force origin HEAD:update

hf-login:
	git fetch origin update
	git switch update
	git pull --ff-only origin update
	python -m pip install -U huggingface_hub
	hf auth login --token "$$HF"

push-hub:
	hf upload rsangam/Drug-Classification ./App . --repo-type=space --commit-message="Sync App files"
	hf upload rsangam/Drug-Classification ./Model Model --repo-type=space --commit-message="Sync Model"
	hf upload rsangam/Drug-Classification ./Results Metrics --repo-type=space --commit-message="Sync Metrics"

deploy: hf-login push-hub
