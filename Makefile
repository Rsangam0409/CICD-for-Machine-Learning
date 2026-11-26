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