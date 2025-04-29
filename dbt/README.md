# QR Code art gallery

## Introduction

This repo aims to create an OLAP Database with data on art pieces from the Metropolitan Museum of Art, but also include QR codes for a link with further details on each art piece. With this, it will be possible to use the dashboard in classrooms for art or history of art studies, but also allow students to access the art piece's link easily and in a fast manner, in order to see each piece up close, with high definition details, if they wish to.

The concept of generating QR codes can also be used in other contexts, such as in corporate meetings, for instance. The use of images are already widespread, such as Powerpoint presentations. But more often than not, people might need to access a link. Simply placing a QR code on the screen when needed, might avoid many e-mail unnecessary exchanges, such as "can you please send me the link for that?", as well as diminishing the cognitive load of the presenter that has to remember which links to send to whom. Should you take a look at this Jira ticket, Google Spreadheet or a company Pdf? There it is, don't need to waste time looking for it. You can concentrate on what is being presented.

### DataTalks.Club Zoomcamp
This is my iteration of the final project propposed by the organizers of the Data Engineering Zoomcamp.
For those who eventually stumble upon this repository and are not aware, the Data Talks Club Engineering Zoomcamp is a nine week free bootcamp. More info on Data Talks Club on their [website](https://datatalks.club/). They have top notch teachers and courses, on different areas of data. I highly recommend checking their work and have learned a lot troughout the course.

## The Project

Description of the project in more technical terms.

### Guidelines and goals

The project guidelines are described on the course's [github](https://github.com/DataTalksClub/data-engineering-zoomcamp/tree/main/projects). They delineate minimum requirements, but allow the participant to choose their preferred tools and programming languages. 

### Pipeline Type

For this project, **batch** pipelines will be created.

### Chosen tools for the project

Infrastructure as Code (IaC): **Terraform**

Workflow Orchestration: **Kestra**

Cloud Storage and Data Warehouse: **Google Cloud** and **Google BigQuery**, respectively

**Ingestion**: dlt

Transformations: **Python Pandas library**


![data_museum drawio](https://github.com/user-attachments/assets/1126d6d6-b96b-4326-ba56-a2a02e85f8a4)


### Chosen Datasets

The chosen Dataset will be obtained from the [Metropolitan Museum of Art API](https://metmuseum.github.io/).


    Problem description
        4 points: Problem is well described and it's clear what the problem the project solves
    Cloud
        4 points: The project is developed in the cloud and IaC tools are used
    Data ingestion (choose either batch or stream)
        Batch / Workflow orchestration
            4 points: End-to-end pipeline: multiple steps in the DAG, uploading data to data lake
    Data warehouse
        4 points: Tables are partitioned and clustered in a way that makes sense for the upstream queries (with explanation)
    Transformations (dbt, spark, etc)
        4 points: Tranformations are defined with dbt, Spark or similar technologies
    Dashboard
        4 points: A dashboard with 2 tiles
    Reproducibility
        4 points: Instructions are clear, it's easy to run the code, and the code works


### Terraform for cloud configuration

Terraform was used for configuration of the cloud resources in Google Cloud. Terraform is a IaC (Infrastructure as code) platform, which allows the user to design, setup, update and ultimately, destroy resources within the cloud. 

IaC is highly desirable, as it enables developers in important aspects such as more control of resources in the cloud, which in the end, translates into financial costs. But apart from this, it allows for consistency among different resources, speed when setting up, ease of management of these resources and versioning. This might be only scratching the surface, but the point is made.

In this project, Terraform was used to setup the bucket (qr_art_gallery) and two BigQuery Datasets (or schemas, in other Data Warehouses), qr_art_gallery_raw and qr_art_gallery_transformed, where the former will hold tabular raw data, and the latter will hold transformed data.

### Kestra for orchestration

Orchestration tools are fundamental in building pipelines, as they allow for the developer to define when should jobs run, which jobs should run, among other things, such as error handlinng, metadata on each run and etc. It functions as a "Trigger" for every step that is necessary to take data from point A (say, the MET API) to point B (say, a storage bucket on the cloud).  

Kestra is an open-source orchestration tool and was a fundamental part of this project. It is present on the majority of the flow, described on the image above.

Thre main flows were developed for this project, namely **from_met_api_to_bucket**, **from_bucket_to_staging** and **from_staged_to_transformed**. The names indicate the function each one serves. For modularity, it is worth considering creating a flow for each new table created, in order to avoid that a possible error of one jeopardizes the whole entirety of the data loading.

### Cloud Storage and Data Warehouse

Cloud computing is a very important aspect of Data Engineering. The chosen cloud service was Google Cloud, as suggested by the course organizers. Google Cloud offers a free trial period, which was also fundamental for this project.

#### Virtual Machine

One of the many resources available on the cloud is the possibility of creating a Virtual Machine trough Google's computing engine services, on the Cloud. This way, data processing need not necessarily be done on your local computer. A VM can be run and be programmed remotely.

#### Cloud Storage

For non-tabular and unstructured data, the Cloud Storage is the Data Lake solution of Google Cloud. It allows "Buckets" to be setup. A bucket might resemble a Google Drive, where non-tabular data can be stored. The Bucket **qr_art_gallery** is the bucket used in this project.

#### Data Warehouse

BigQuery is Google Cloud's solution for configuring Data Warehouses. This allows for an OLAP (Online Analytical Processing) querying (i.e.: retrieving large amounts of data), for analytics tasks. 

### Data Ingestion

One of the fundamental parts of a pipeline is data ingestion, wich roughly means retrieving data from a given source. For this, dlt was used. Dlt stands for Data Loading Tool, and is a Python Library designed and optimized for, as the names suggests, loading data.

Despite mantaining a beautiful and fully functioning API, which I absolutely loved, retrieving data from the Metropolitan was an unexpected challange, at least in the context of this project. While many APIs allow for a bulk extraction ("Please, could you send me data on all your available collection objects, all at once?"), the requests had to be done relatively to each collection object, individually ("Please, could you send me data on object with Id 74? Thanks. Please, could you send me data on object with Id 75? Thanks. Please(...)"). 

The total count of objects is around half a million, which has shown to be a sufficiently large task to require some optimization. At first, retrieving the objects sequentially (iterating over a list of the object ids) seemed the way to go. However, this has shown to be way too slow, at roughly 5 to 6 requests per second. I've researched and found out about Python and dlt capabilities for Async computing. This bumped my request rate per second to 136 requests per second. 

```
import dlt
import httpx


@dlt.transformer
async def pokemon(id):
    async with httpx.AsyncClient() as client:
        r = await client.get(f"https://pokeapi.co/api/v2/pokemon/{id}")
        return r.json()

# Get Bulbasaur and Ivysaur (you need dlt 0.4.6 for the pipe operator working with lists).
print(list([1,2] | pokemon()))

```

This is a manyfold improvement, so large that it had even to be limited, as on the documentation from the MET API, they ask for keeping the requests under 80 per second. The libray AioLimiter was used, in an attempt to honor the museum's request (and also so my IP woudn't be blocked from accessing the API). Below is the example, given on dlt [website](https://dlthub.com/docs/general-usage/resource) that was the basis for my code that handled the extraction (no AioLimiter in their example).

The Python script that handles the extraction from the MET API phase is triggered by Kestra, where a task that creates a docker container with Python is setup. 

### Transformations

Approaching the final stages of the pipeline, transformations are made with the Python Pandas Library. Python was necessary for its larger scope. The library qrcode was installed, and with it a QR code could be generated for each object.



