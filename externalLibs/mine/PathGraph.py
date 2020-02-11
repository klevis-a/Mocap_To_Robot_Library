import pandas as pd

from plotly.offline import download_plotlyjs, init_notebook_mode, plot, iplot
import plotly.graph_objs as go
from plotly import subplots
import numpy as np
import colorlover as cl

init_notebook_mode(connected=True)

def figure2D(traceList):
    data = []
    divisions = len(traceList)
    if divisions < 16:
        divisions = 16
    colors = cl.interp(cl.scales[str(9)]['div']['PiYG'], divisions)
    for index,trace in enumerate(traceList):
        scatterTrace = go.Scatter(
            text=trace[2],
            x = trace[0][0],
            y = trace[0][1],
            mode = 'markers',
            marker = dict(size=2,color = colors[index]),
            hoverinfo='text+x+y',
            name = trace[2])
        data.append(scatterTrace)
    figure = go.Figure(data=data)
    return figure
	
def plot2D1X3(filename,title,trace1,trace2,trace3,height=450,inline=False):
    traceX = go.Scatter(
        x=trace1[0].index,
        y=trace1[0]
    )

    traceY = go.Scatter(
        x=trace2[0].index,
        y=trace2[0]
    )
    
    traceZ = go.Scatter(
        x=trace3[0].index,
        y=trace3[0]
    )

    figure = subplots.make_subplots(rows=1,cols=3,print_grid=False,subplot_titles=(trace1[1],trace2[1],trace3[1]));

    figure.append_trace(traceX, 1, 1)
    figure.append_trace(traceY, 1, 2)
    figure.append_trace(traceZ, 1, 3)

    figure['layout']['xaxis1'].update(title=trace1[2])
    figure['layout']['xaxis2'].update(title=trace2[2])
    figure['layout']['xaxis3'].update(title=trace3[2])

    figure['layout']['yaxis1'].update(title=trace1[3])
    figure['layout']['yaxis2'].update(title=trace2[3])
    figure['layout']['yaxis3'].update(title=trace3[3])

    figure['layout'].update(title=title)
    figure['layout'].update(height=height)
    figure['layout'].update(showlegend=False)
    
    if inline:
        iplot(figure, filename=filename)
    else:
        plot(figure, filename=filename)
	
def figure3D(traceList, camera=None):
    data = []
    for trace in traceList:
        marker_trace = dict(text=trace[3],x = trace[0][0], y = trace[0][1], z = trace[0][2],
                 type = "scatter3d",
                 mode = trace[4],
                 marker = dict(size=2,color = trace[1]),
                 hoverinfo='text+x+y+z',
                 name = trace[2])
        data.append(marker_trace)
		
    if camera is None:    
        camera = dict(
            up=dict(x=0, y=0, z=1),
            center=dict(x=0, y=0, z=0),
            eye=dict(x=1, y=2.5, z=1)
        )

    layout = dict(
        title='Kinematic Data',
        scene=dict(
            xaxis=dict(title='X',linewidth=3,gridwidth=5),
            yaxis=dict(title='Y',linewidth=3,gridwidth=5),
            zaxis=dict(title='Z',linewidth=3,gridwidth=5),
            aspectratio = dict(x=1, y=1, z=1),
            aspectmode = 'data',
            camera=camera
        ),
        margin=dict(l=0,r=0,b=0,t=0),
        showlegend=True,
        legend=dict(x=0.6,y=0.6)
    )

    figure = go.Figure(data=data, layout=layout)
    return figure

def readQuat6D(filename):
    points = pd.read_csv(filename, header=3, index_col=0, usecols=[i+1 for i in range(8)])
    points.columns = ['q0', 'qx', 'qy', 'qz', 'x', 'y', 'z', 'error']
    return points
	
def readEuler(filename):
    points = pd.read_csv(filename, header=3, index_col=0, usecols=[i+1 for i in range(7)])
    points.columns = ['Rz', 'Ry', 'Rx', 'x', 'y', 'z', 'error']
    return points
	
def readCal6D(filename):
    points = pd.read_csv(filename, header=0, index_col=0, usecols=[i for i in range(7)])
    points.columns = ['x', 'y', 'z', 'W', 'P', 'R']
    return points
	
def createXYZ(dataset, x, y, z):
    return [dataset[x],dataset[y],dataset[z]]
	
def plotXYZ(filename, *traces):
    plot_definition = []
    divisions = len(traces)
    if divisions < 16:
        divisions = 16
    colors = cl.interp(cl.scales[str(9)]['div']['PiYG'], divisions)
    for index,trace in enumerate(traces):
        plot_definition.append((createXYZ(trace[0], 'x', 'y', 'z'), colors[index], trace[1], trace[0].index, 'markers+lines'))
    plot(figure3D(plot_definition), filename=filename);
	
#points, name, color, markers+lines
def plotXYZC(filename, camera=None, *traces):
    plot_definition = []
    for index,trace in enumerate(traces):
        plot_definition.append((createXYZ(trace[0], 'x', 'y', 'z'), trace[2], trace[1], trace[0].index, trace[3]))
    plot(figure3D(plot_definition, camera), filename=filename);
	
def plotXYZArray(filename, traces):
    plot_definition = []
    divisions = len(traces)
    if divisions < 16:
        divisions = 16
    colors = cl.interp(cl.scales[str(9)]['div']['PiYG'], divisions)
    for index,trace in enumerate(traces):
        plot_definition.append((createXYZ(trace[0], 'x', 'y', 'z'), colors[index], trace[1], trace[0].index, 'markers+lines'))
    plot(figure3D(plot_definition), filename=filename);

def removeNoData(df):
    return df[df['x'] > -3E28]
