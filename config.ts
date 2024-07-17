import { Config } from "simpleg";

/**
 * 
 * presentation: async () => {
    console.clear();
    console.log(
      `
      ███████╗██████╗ ██╗ ██████╗██╗  ██╗
      ██╔════╝██╔══██╗██║██╔════╝██║ ██╔╝
      █████╗  ██████╔╝██║██║     █████╔╝ 
      ██╔══╝  ██╔══██╗██║██║     ██╔═██╗ 
      ███████╗██║  ██║██║╚██████╗██║  ██╗
      ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝
      `
    );
  },
 */

const config: Config = {
  presentation: `
      ███████╗██████╗ ██╗ ██████╗██╗  ██╗
      ██╔════╝██╔══██╗██║██╔════╝██║ ██╔╝
      █████╗  ██████╔╝██║██║     █████╔╝ 
      ██╔══╝  ██╔══██╗██║██║     ██╔═██╗ 
      ███████╗██║  ██║██║╚██████╗██║  ██╗
      ╚══════╝╚═╝  ╚═╝╚═╝ ╚═════╝╚═╝  ╚═╝
      `,

  templatesFolder: "./templates",
  folders: [
    {
      name: "Linux",
      project: {
        templates: {
          local: [
            {
              name: "\x1b[1m\x1b[36mBSPWM\x1b[37m\x1b[0m",
              path: "bspwm",
            },
          ],
        },
      },
    },
    {
      name: "Web",
      project: {
        templates: {
          local: [
            {
              name: "\x1b[1m\x1b[36mSpring Boot - Security\x1b[37m\x1b[0m",
              path: "security",
            },
          ],
        },
      },
    },
  ],
};

export default config;
