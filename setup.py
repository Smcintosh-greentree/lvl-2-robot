from setuptools import setup

setup(
    name='mylibrary',
    version='0.1',
    description='My custom Robot Framework library',
    author='Your Name',
    author_email='your.email@example.com',
    packages=['TestLibrary', 'tasks'],
    install_requires=[
        'robotframework'
    ]
)
