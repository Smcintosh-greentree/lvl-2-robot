from setuptools import setup

setup(
    name='mylibrary',
    version='1.0',
    description='My custom Robot Framework library',
    author='Your Name',
    author_email='your.email@example.com',
    packages=['TestLibrary', 'tasks', 'Libraries'],
    install_requires=[
        'robotframework'
    ]
)
