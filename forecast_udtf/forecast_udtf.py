import sys
import ast
import pandas as pd
from prophet import Prophet

class forecast:
    def __init__(self):
        self._dates = []
        self._values = []
        
    def process(self, id, y, d, periods):
        self._dates.append(d)
        self._values.append(y)
        self._id = id
        self._periods = periods
        return ((id, y, d), )
    def end_partition(self):
    
        df = pd.DataFrame(list(zip(self._dates, self._values)),
               columns =['ds', 'y'])
               
        model = Prophet()
        model.fit(df)
        future_df = model.make_future_dataframe(
            periods=self._periods, 
            include_history=False)
        forecast = model.predict(future_df)
        for row in forecast.itertuples():
            yield(self._id, row.yhat, row.ds)
            yield(self._id + '_lower', row.yhat_lower, row.ds)
            yield(self._id + '_upper', row.yhat_upper, row.ds)

if __name__ == '__main__':
    # if len(sys.argv) > 1:
    #     print(
    #         forecast(ast.literal_eval(sys.argv[1]),
    #           ast.literal_eval(sys.argv[2]),
    #           ast.literal_eval(sys.argv[3])))
    # else:
    #     print(forecast())
    print("Do nothing, will run in Snowflake")