from setuptools import setup

setup(
    name='mylibrary',
    version='1.0',
    description='My custom Robot Framework library',
    author='Your Name',
    author_email='your.email@example.com',
    packages=['Libraries'],
    package_dir={'Libraries': 'Libraries'},
    package_data={
        'Libraries': ['RobotLibrary.robot'],
    },
    install_requires=[
        'robotframework'
    ]
)
