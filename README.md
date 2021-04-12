# matlab-whole-body-simulator

**matlab-whole-body-simulator** is a simulator for the humanoid robots. It has been designed to work in Simulink.
In the simulator the ground is assumed to be flat and the contact forces are computed using the **Maximum dissipation principle** and under the linear approximation of the friction cones assumption.

## :hammer: Dependencies

- [Matlab/Simulink 2019b](https://it.mathworks.com/products/matlab.html)
- [YARP](https://github.com/robotology/yarp) & [yarp-matlab-bindings](https://github.com/robotology/yarp-matlab-bindings): Yarp Resource Finder.
- [WBToolbox](https://github.com/robotology/wb-toolbox): WB-Toolbox library Simulink blocks.
- [iDynTree](https://github.com/robotology/idyntree): Dynamic computations (through bindings) and WB-Toolbox library dependency.
- [qpOASES](https://github.com/robotology-dependencies/qpOASES): QP solver for estimating the contact wrenches.
- [icub-models](https://github.com/robotology/icub-models): access to the iCub models.
- [Whole-Body-Controllers](https://github.com/robotology/whole-body-controllers): `+wbc` package helpers for kinematics & dynamics computations.

It is recommended to install these dependencies using the [robotology-superbuild](https://github.com/robotology/robotology-superbuild) resources:
- Either installing the full superbuild from source.
- Either installing the required binary packages derived from the above listed dependencies, using the [miniforge conda distribution](https://github.com/conda-forge/miniforge) package manager, from the robotology channel.

## :floppy_disk: Installing the dependencies through the robotology superbuild source

- Clone and build the robotology-superbuild following the steps in https://github.com/robotology/robotology-superbuild/blob/master/README.md.
- `icub-models`: set the profile option `ROBOTOLOGY_ENABLE_CORE`.
- `iDynTree`, `WBToolbox`, `Whole-Body-Controller`, `qpOASES` and `yarp-matlab-bindings`: set the profile option `ROBOTOLOGY_ENABLE_DYNAMICS` and CMake option  `ROBOTOLOGY_USES_MATLAB`.

**Note 1:** In general, for selecting the profile CMake options according to the sub-projects to install, refer to the table in the section [Profile CMake Options](https://github.com/robotology/robotology-superbuild/blob/master/doc/profiles.md#profile-cmake-options).
**Note 2:** By setting the profile `ROBOTOLOGY_ENABLE_DYNAMICS`in the superbuild cmake options. The `qpOASES` library will then be installed along with `iDynTree` as an external dependency.
**Note 3:** Previously, two other optional QP solvers were available: OSQP and the native MATLAB solver `quadprog`. OSQP bindings and `quadprog` are not supported by the Simulink code generation build option in the `step_block` MATLAB System block. For this reason, the `step_block` MATLAB System block uses the qpOASES WBT block through a Simulink function call, and this choice is hardcoded in the class `Contacts`. As soon as the OSQP WBT block is created, it will replace the qpOASES Solver block.

## :floppy_disk: Installing the dependencies from the conda robotology channel

1. Install the conda miniforge distribution following https://github.com/robotology/robotology-superbuild/blob/master/doc/install-miniforge.md#linux. Remember to restart your shell session or run `source ~/.bashrc` (`~/.bash_profile` on MacOS) for the `conda init` command to take effect.
2. Install Mamba, create a new environment and install the robotology dependency binaries:
    ```
    $ conda install mamba
    $ conda create -n robotologyenv
    $ conda activate robotologyenv
    $ mamba install -c robotology iDynTree qpOASES icub-models wb-toolbox whole-body-controllers
    ```
    To read more about installing robotology-superbuild package binaries refer to https://github.com/robotology/robotology-superbuild/blob/master/doc/conda-forge.md#binary-installation.
3. Check the MATLABPATH environment variable. It should now have:
    ```
    <user-home-dir>/miniforge3/envs/robotologyenv/mex: <user-home-dir>/miniforge3/envs/robotologyenv/share/WBToolbox: <user-home-dir>/miniforge3/envs/robotologyenv/share/WBToolbox/images
    ``` 
    Mex libraries:
    ```
    $ ls <user-home-dir>/miniforge3/envs/robotologyenv/mex/
    
    +iDynTree
    +iDynTreeWrappers
    +wbc
    BlockFactory.mexmaci64
    BlockFactory.tlc
    SwigGet.m
    SwigMem.m
    SwigRef.m
    iDynTreeMEX.mexmaci64
    mesh2tri.m
    ```
4. Clone the repository  `matlab-whole-body-simulators`
    ```
    $ git clone https://github.com/dic-iit/matlab-whole-body-simulator.git
    ```
5. Run matlab in the same conda environment.
6. Change working directory to the root path of repository `matlab-whole-body-simulators`.
7. Open and run the model `test_matlab_system_2020b.mdl`.

## :runner: How to use the simulator

1. Connect your controller to the robot block. This block takes as imput the **joints torque**, **motor inertia** and an eventual **generalized external wrench**. It outputs the robot **state**, the contact wrenches **wrench_LFoot** and **wrench_RFoot**, respectively applied to the left and right foot (sole frames), and **kinDynOut**, an output bus exposing all the computed dynamics quantities relevant for debugging or the extension of dynamics computations in external blocks (emulation of an IMU sensor, of pressure sensors on the feet, etc).
2. Select the robot model by setting the environment variable `YARP_ROBOT_NAME` (e.g. `setenv('YARP_ROBOT_NAME','iCubGenova04')`). The available models are:
    | Model description | iCub robot (iCubGenova04) | RRBot from Gazebo |
    | --- | --- | --- |
    | Preview | <img width="982" alt="iCubGenova04" src="https://user-images.githubusercontent.com/6848872/114422028-31652f00-9bb6-11eb-987b-62e9b5b38811.png"> | <img width="930" alt="RRbot1" src="https://user-images.githubusercontent.com/6848872/114421414-910f0a80-9bb5-11eb-8256-a1f8678fec5a.png"> |
    | $YARP_ROBOT_NAME | `'iCubGenova04'` | `'RRbot1'` |
    
3. Set the configuration parameters `robot_config`, `contact_config` and `physics_config`.
<img width="1105" alt="RobotDynWithContacts" src="https://user-images.githubusercontent.com/6848872/114416537-13e19680-9bb1-11eb-8948-9fd7c9f8079b.png">

To run and example open and launch `test_matlab_system.mdl`. It also contains a callback to the `init` file that retrieves the needed information.
