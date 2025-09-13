import pandas as pd
import sklearn
from sklearn.model_selection import train_test_split
from sklearn.preprocessing import LabelEncoder, StandardScaler
from sklearn.ensemble import RandomForestClassifier
from sklearn.metrics import accuracy_score, confusion_matrix, classification_report, roc_curve, roc_auc_score
import matplotlib.pyplot as plt
import seaborn as sns

df = pd.read_csv('cleaned_cali_2022.csv', sep=';')

x = df[["loan_amount", "property_value", "income", "debt_to_income_midpoint", "applicant_age_midpoint", "applicant_sex_name", "applicant_race_1_name"]]
y = df["action_name"].apply(lambda x: 1 if x == "Loan originated" else 0)

x = x.fillna(x.mean)

for col in x.select_dtypes(include='number'):
	x.fillna({col: x[col].median()}, inplace=True)

for col in x.select_dtypes(include='object'):
	x.fillna({col: x[col].mode()[0]}, inplace=True)

label_encoders = {}
for col in x.select_dtypes(include='object'):
    x[col] = x[col].astype(str)
    le = LabelEncoder()
    x[col] = le.fit_transform(x[col])

target_le = LabelEncoder()
y = target_le.fit_transform(y)

scaler = StandardScaler()
num_cols = x.select_dtypes(include='number').columns
x[num_cols] = scaler.fit_transform(x[num_cols])

x_train, x_test, y_train, y_test = train_test_split(x, y, test_size = 0.2, random_state = 42)
model = RandomForestClassifier(n_estimators = 100, random_state = 42)
model.fit(x_train, y_train)

y_pred = model.predict(x_test)

print("Accuracy: ", accuracy_score(y_test, y_pred))
print("Confusion Matrix:")
print(confusion_matrix(y_test, y_pred))
print("Classification Report:")
print(classification_report(y_test, y_pred))

importances = model.feature_importances_
feature_importance_df = pd.DataFrame({'feature': x.columns, 'importance': importances}).sort_values(by='importance', ascending=False)

plt.figure(figsize=(10,6))
sns.barplot(x='importance', y='feature', data=feature_importance_df)
plt.title("Feature Importance")
plt.show()

y_prob = model.predict_proba(x_test)[:,1]

fpr, tpr, thresholds = roc_curve(y_test, y_prob)
roc_auc = roc_auc_score(y_test, y_prob)

plt.figure(figsize=(6, 6))
plt.plot(fpr, tpr, color="blue", label=f"ROC curve (AUC = {roc_auc:.2f})")
plt.plot([0, 1], [0, 1], color="gray", linestyle="--")  # random guess line
plt.xlabel("False Positive Rate")
plt.ylabel("True Positive Rate")
plt.title("ROC Curve - Loan Approval Prediction")
plt.legend(loc="lower right")
plt.show()

cm = confusion_matrix(y_test, y_pred)
plt.figure(figsize=(6, 4))
sns.heatmap(cm, annot=True, fmt="d", cmap="Reds", cbar=False,
            xticklabels=['Not Approved', 'Approved'],
            yticklabels=['Not Approved', 'Approved'])
plt.xlabel("Predicted")
plt.ylabel("Actual")
plt.title("Confusion Matrix")
plt.show()