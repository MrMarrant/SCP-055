-- SCP-055, A representation of a paranormal object on a fictional series on the game Garry's Mod.
-- Copyright (C) 2023  MrMarrant aka BIBI.

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

SCP_055_CONFIG.PanelPassword =
[[<head>
    <title>Panel Password</title>
    <style>
        body {
            text-align: center;
            margin: 0;
            padding: 0;
        }

        input {
            width: 300px;
            height: 50px;
            text-align: center;
            font-size: 40px;
            background-color: #000000;
            color: #ffffff;
            border:0;
            outline:0;
        }

        input:focus {
            outline:none!important;
        }

        .input-container {
            display: flex;
            justify-content: center;
            margin-top: 50px;
        }

        button {
            width: 200px;
            height: 40px;
            border-radius: 10px;
            background-color: #333333;
            color: #ffffff;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .button-container {
            display: flex;
            justify-content: center;
            margin-top: 40px;
        }

        button:hover {
            background-color: #555555;
        }
    </style>
</head>
    <body>
        <div class="button-container">
            <input type="text" maxlength="6" id="InputPassword" oninput="handleInput(this)" />
        </div>
        <br>
        <div class="button-container">
            <button onclick="checkPassword()">ENTER</button>
            <button onclick='quitPanel()'>QUIT</button>
        </div>
    
        <script>
            var inputElem = document.getElementById('InputPassword'); 
            window.addEventListener('load', function(e) {
                inputElem.focus();
            })

            function handleInput(input) {
                input.value = input.value.toUpperCase();
            }

            function checkPassword() {
                var input = document.getElementById('InputPassword');
                var characters = input.value.toLowerCase();

                if (characters != "") {
                    console.log("RUNLUA:scp_055.CheckPassword('"+characters+"')")
                }
            }

            function quitPanel() {
                console.log("RUNLUA:scp_055.UnCheckBriefcase()")
            }
        </script>
    </body>]]