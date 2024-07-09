mkdir -p dashboard

dashboards=$(aws cloudwatch list-dashboards --query 'DashboardEntries[*].DashboardName' --output text)
for dashboard in $dashboards
do     
 aws cloudwatch get-dashboard --dashboard-name "$dashboard" --output json > "dashboard/${dashboard// /_}.json"
done
