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

	echo "## Confusion Matrix Plot" >> report.md
	echo '![Confusion Matrix](./Results/model_results.png)' >> report.md
	cat report.md

	cml comment create report.md

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