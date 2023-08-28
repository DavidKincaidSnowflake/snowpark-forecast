# Helpful Snowpark Quickstarts
# https://quickstarts.snowflake.com/guide/data_engineering_pipelines_with_snowpark_python/index.html#0
# https://quickstarts.snowflake.com/guide/getting_started_with_snowpark_dataframe_api/index.html?index=..%2F..index#0
# https://quickstarts.snowflake.com/guide/getting_started_with_snowpark_python_scikit/index.html?index=..%2F..index#0
# https://quickstarts.snowflake.com/guide/machine_learning_with_snowpark_python/index.html?index=..%2F..index#0

import sys
import ast
import pandas as pd
from prophet import Prophet

def forecast(dates, vals, periods):
    df = pd.DataFrame(list(zip(dates, vals)), columns=['ds','y'])

    model = Prophet()
    model.fit(df)
    future_df = model.make_future_dataframe(periods=periods, include_history=False)

    forecast = model.predict(future_df)
    return [[x.yhat, x.ds] for x in forecast.itertuples()]

if __name__ == '__main__':
    if len(sys.argv) > 1:
        print(
            forecast(ast.literal_eval(sys.argv[1]),
              ast.literal_eval(sys.argv[2]),
              ast.literal_eval(sys.argv[3])))
    else:
        print(forecast())